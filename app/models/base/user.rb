class Base::User < ApplicationRecord
  has_secure_password
  has_many :jwt_blacklists
  belongs_to :company, foreign_key: :company_id, class_name: 'Base::Company'
  belongs_to :role, foreign_key: :role_id, class_name: 'Base::Role'
  has_many :workspaces, class_name: 'Base::Workspace'
  has_many :workspace_role_details, class_name: 'Base::WorkspaceRoleDetail'
  has_many :documents, class_name: 'Document::Document'
  has_many :issues, class_name: 'Document::Issue'
  has_many :issue_comments, class_name: 'Document::IssueComment'

  validates :uid, uniqueness: { case_sensitive: false }, length: { maximum: 50 }
  validates :firstname, presence: true, length: { in: 1..50 }
  validates :lastname, presence: true, length: { in: 1..50 }
  validates :email, length: { maximum: 100 }, uniqueness: { case_sensitive: false },
                    format: { with: /\A[\w+\-.]+@[a-z\d-]+(\.[a-z\d-]+)*\.[a-z]+\z/i }
  validates :password, length: { minimum: 8 }, format: { with: /\A^(?=.*\d)(?=.*([a-z]|[A-Z]))([\x21-\x7E]){8,}$\z/ }
  validates :confirmation_code, length: { is: 6 }, format: { with: /\A[a-zA-Z0-9]+\z/ }

  default_scope { left_joins(:company).where(company: { uid: Current.current_company }) }

  def password_code_valid?
    return false unless confirmation_expires.present?
    confirmation_expires > Time.now.utc
  end

  def reset_password!(password)
    self.confirmation_code = nil
    self.confirmation_expires = nil
    self.password = password
    save!
  end

  def update_login_count()
    increment!(:login_count)
  end

  def self.authenticated_user(params)
    user = find_by_email(params[:email].downcase)
    if user&.password_digest? && user.authenticate(params[:password])
      user.increment!(:login_count)
    end
  end

  def self.confirmation_code_sent(params)
    user = unscoped.find_by_email(params[:email]&.downcase)
    if user
      user.update!(confirmation_code: SecureRandom.alphanumeric(6), confirmation_expires: Time.now.utc + 5.minutes)
      # UserMailer.reset_password(user).deliver_now!
    end
    user
  end

  def has_permission?(action, resource)
    return false if role_id.nil?

    role = Base::Role.find(role_id)
    m = Base::Module.find_by('name ILIKE :keyword', keyword: "#{resource.strip}")
    return false if m.nil?
    role_details = role.role_details.find_by(module_id: m.id)
    if role_details&.write? || role_details&.admin?
      true
    elsif role_details&.read? && action == Base::RoleDetail.actions[:read]
      true
    else
      false
    end
  end
end

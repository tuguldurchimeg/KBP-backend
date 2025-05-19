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
  validates :password, length: { minimum: 8 }, format: { with: /\A^(?=.*\d)(?=.*([a-z]|[A-Z]))([\x21-\x7E]){8,}$\z/ }, allow_blank: true
  validates :confirmation_code, length: { maximum: 6 }, format: { with: /\A[a-zA-Z0-9]+\z/ }, allow_blank: true

  default_scope { left_joins(:company).where(company: { uid: Current.current_company }) }

  def password_code_valid?
    return false unless confirmation_expires.present?
    confirmation_expires > Time.now.utc
  end

  def reset_password!(password)
    self.confirmation_code = nil
    self.confirmation_expires = nil
    self.password = password
    self.password_change_required = false
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
    end
    user
  end

  def self.new_user(params)
    user = Base::User.new(params)
    ActiveRecord::Base.transaction do
      company = Base::Company.find_by(uid: Current.current_company)

      user.uid = SecureRandom.uuid
      user.role = company.roles.first
      user.company = company
      user.password = generate_password
      user.password_change_required = true
      user.save!
      PasswordMailer.with(user: user).send_password.deliver_now
    end
    user
  end

  def self.generate_password(length = 8)
    # At least 1 digit, 1 lowercase, 1 uppercase, 1 symbol
    chars = {
      lower: ('a'..'z').to_a,
      upper: ('A'..'Z').to_a,
      digits: ('0'..'9').to_a,
      symbols: %w[! @ # $ % ^ & * - _ = +]
    }

    base = [
      chars[:lower].sample,
      chars[:upper].sample,
      chars[:digits].sample,
      chars[:symbols].sample
    ]

    remaining = (chars[:lower] + chars[:upper] + chars[:digits] + chars[:symbols]).sample(length - 4)
    (base + remaining).shuffle.join
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

class Base::User < ApplicationRecord
  has_secure_password
  has_many :jwt_blacklists
  belongs_to :company, foreign_key: :company_id
  belongs_to :role, foreign_key: :role_id
  has_many :workspaces
  has_many :documents, foreign_key: :author_id
  has_many :issues, foreign_key: :created_by_id
  has_many :issue_comments

  validates :uid, uniqueness: { case_sensitive: false }, length: { maximum: 50 }
  validates :firstname, presence: true, length: { in: 1..50 }
  validates :lastname, presence: true, length: { in: 1..50 }
  validates :email, length: { maximum: 100 }, uniqueness: { case_sensitive: false },
                    format: { with: /\A[\w+\-.]+@[a-z\d-]+(\.[a-z\d-]+)*\.[a-z]+\z/i }
  validates :password, length: { minimum: 8 }, format: { with: /\A^(?=.*\d)(?=.*([a-z]|[A-Z]))([\x21-\x7E]){8,}$\z/ },
                       allow_blank: true

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

  def update_login_count(provider_id)
    update(provider_id: provider_id)
    increment!(:login_count)
  end

  def self.authenticated_user(params)
    user = find_by_email(params[:email].downcase)
    if user&.password_digest? && user.authenticate(params[:password])
      user.increment!(:login_count)
    end
  end

  def self.confirmation_code_sent(params)
    user = find_by_email(params[:email]&.downcase)
    if user
      user.update!(sign_in_failed: 0, locked_at: nil) if user.locked_at?
      user.update!(confirmation_code: rand(1000..9999), confirmation_expires: Time.now.utc + 5.minutes)
      # UserMailer.reset_password(user).deliver_now!
    end
    user
  end
end

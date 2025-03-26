require 'digest'

class JsonWebToken
  SECRET_KEY = ENV['SECRET_KEY_BASE'].to_s
  REFRESH_TOKEN_SECRET_KEY = ENV['REFRESH_TOKEN_SECRET_KEY_BASE'].to_s

  def self.encode(payload, exp)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def self.encode_refresh_token(payload, exp)
    payload[:exp] = exp.to_i
    JWT.encode(payload, REFRESH_TOKEN_SECRET_KEY)
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new decoded
  end

  def self.decode_refresh_token(token)
    decoded = JWT.decode(token, REFRESH_TOKEN_SECRET_KEY)[0]
    HashWithIndifferentAccess.new decoded
  end

  def self.get_tokens(payload)
    payload[:token_at] = Time.now.to_i
    user = User.find_by_email(payload[:email]&.downcase)
    {
      id: user.id,
      uid: user.uid,
      email: user.email,
      access_token: JsonWebToken.encode(payload, 1.hour.from_now),
      refresh_token: JsonWebToken.encode_refresh_token(payload, 1.day.from_now),
      sign_in_count: user.login_count,
      password_change_required: user.password_change_required
    }
  end
end

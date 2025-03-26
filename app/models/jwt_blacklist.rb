class JwtBlacklist < ApplicationRecord
  belongs_to :user

  validates :user_id, numericality: { only_integer: true }

  def self.add(user_id, header, decoded)
    if decoded.present?
      exp = decoded['exp'] if decoded['exp'].present?
      token_at = decoded['token_at'] if decoded['token_at'].present?
    end
    new(user_id: user_id, jwt: header, exp: exp, token_at: token_at).save!
  end
end

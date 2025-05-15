class SocialAuthentication
  GOOGLE_VALIDATE_URI = 'https://www.googleapis.com/oauth2/v3/tokeninfo'.freeze
  GOOGLE_INFO_URI = 'https://www.googleapis.com/oauth2/v3/userinfo'.freeze

  def self.google_authentication(access_token)

    token_info = HTTParty.get(
      GOOGLE_INFO_URI,
      headers: { 'Authorization' => "Bearer #{access_token}" }
    )
    # token_info = HTTParty.get(GOOGLE_VALIDATE_URI, query: { id_token: access_token })
    return nil unless token_info.code == 200

    {
      id: token_info.parsed_response['sub'],
      name: token_info.parsed_response['given_name'],
      email: token_info.parsed_response['email']
    }
  end
end

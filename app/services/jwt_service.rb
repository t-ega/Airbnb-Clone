module JwtService

  HMAC_SECRET = Rails.application.credentials.devise_jwt_secret_key!.freeze
  EXPIRY_TIME = (Time.now + 1.day).to_i
  def sign_user(user:)
    return unless user.is_a?(User)
    claim = {user_id: user.id, exp: EXPIRY_TIME}

    JWT.encode claim, HMAC_SECRET, 'HS256'
  end

  def sign_out_user(claim)
    token = decoded_token(claim)
    return unless token

    user_id = token[0]["user_id"]
    exp = token[0]["exp"]

    # Blacklist the token
    JwtDenylist.create(jti:user_id, exp:)
  end

  def token_blacklisted?(jti:)
    JwtDenylist.exists?(jti:)
  end

  private
  def decoded_token(token)
    begin
       JWT.decode(token, HMAC_SECRET)
    rescue JWT::DecodeError
      nil
    end
  end
end

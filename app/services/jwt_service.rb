module JwtService

  HMAC_SECRET = Rails.application.credentials.devise_jwt_secret_key!.freeze
  EXPIRY_TIME = (Time.now + 1.day).to_i

  def sign_user(user:)
    return unless user.is_a?(User)
    id = SecureRandom.uuid
    claim = {user_id: user.id, exp: EXPIRY_TIME, id:id}

    JWT.encode claim, HMAC_SECRET, 'HS256'
  end

  def sign_out_user(claim)
    token = decoded_token(claim)
    return unless token

    jti = token[0]["id"]
    exp = token[0]["exp"]

    date = Time.at(exp).to_date

    # Blacklist the token
    JwtDenylist.create!(jti:, exp:date)
  end

  def token_blacklisted?(jti:)
    JwtDenylist.exists?(jti:)
  end

  private
  def decoded_token(token)
    begin
       JWT.decode(token, HMAC_SECRET, true, {algorithm: "HS256"})
    rescue JWT::DecodeError
      nil
    end
  end
end

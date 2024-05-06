module AuthService

  HMAC_SECRET = Rails.application.credentials.devise_jwt_secret_key!.freeze
  EXPIRY_TIME = 1.day.from_now.to_i
  Time.zone = "UTC"

  class << self
    def sign_user(user)
      return unless user.is_a?(User)

      session_id = generate_unique_session_id
      Session.create!(session_id: session_id, user_id: user.id)

      claim = {user_id: user.id, exp: EXPIRY_TIME, session_id: session_id}

      JWT.encode claim, HMAC_SECRET, 'HS256'
    end

    def current_user(authorization_token)
      return unless authorization_token

      token = decode_token(authorization_token)
      return unless token

      session_id = token[0].fetch("session_id", nil)
      return unless session_id  # Don't process if there is no session id on it.

      # Check if the session is still valid
      valid = session_valid?(session_id)
      return unless valid

      user_id = token[0]["user_id"]
      User.find(user_id)
    end

    def destroy_token_session(claim)
      token = decode_token(claim)
      return unless token

      session_id = token[0]["session_id"]
      user_id = token[0]["user_id"]

      current_time = Time.zone.now

      # Set the logout field on the sessions
      session = Session.find_by(session_id:session_id, user_id:user_id)
      return unless session

      session.update!(logout_time:current_time) if session.logout_time.nil?
    end

    def send_reset_instructions(user)
      return unless user.is_a?(User)
      user.send_reset_password_instructions
    end

    def session_valid?(session_id)
      Session.find_by(session_id:session_id).logout_time.nil?
    end

    private
    def generate_unique_session_id
      loop do
        session_id = SecureRandom.uuid
        break session_id unless Session.exists?(session_id: session_id)
      end
      end

    def decode_token(token)
      begin
         JWT.decode(token, HMAC_SECRET, true, {algorithm: "HS256"})
      rescue JWT::DecodeError => e
        nil
      end
    end
    end
end

module TokenService
  module Purpose
    RESET = :password_reset.freeze
    CONFIRMATION = :confirmation.freeze
  end

  # Leave here to avoid Time zone issues
  Time.zone = "UTC"

  class << self
    def find_token(token:, user_id:, purpose:)
      token = Token.find_by(token:, user_id:, is_used: false, purpose:)
      return unless token

      expired = token.expires_at < Time.zone.now
      return if expired

      token
    end

    # Create a token for a specified user.
    # Default expiry time is 1 day, but you can override.
    # this by passing in the expiry time as a second argument.
    # The purpose states what the token generated is for
    # e.g :password_reset
    def create_token(user_id:, expires_at: nil, purpose:)
      rand_token = generate_token
      expires_at ||= 1.day.from_now.to_i
      Token.create(user_id:user_id, token: rand_token, expires_at:expires_at, purpose:purpose)
    end

    def update_token_status(token)
      # We can avoid querying the db for that token
      return unless token.is_a?(Token)
      token.update!(is_used: true)
    end

    private
    def generate_token
      loop do
        token = rand(1000..9999)
        break token unless Token.exists?(token: token)
      end
    end
  end
end
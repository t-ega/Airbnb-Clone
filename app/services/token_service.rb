module TokenService

  def find_token(token:, user_id:)
    token = Token.find_by(token:, user_id:)
    return unless token

    expired = token.expires_at > Time.now
    return if expired

    token
  end

  # Create a token for a specified user.
  # Default expiry time is 1 day, but you can override
  # this by passing in the expiry time as a second argument
  def create_token(user_id, expires_at = nil)
    rand_token = generate_token
    expires_at ||= 1.day.from_now.to_i
    Token.create(user_id:, token: rand_token, expires_at:)
  end

  def update_token_status(token)
    # We can avoid querying the db for that token
    return unless token.is_a?(Token)
    token.update!(is_used: true)
  end

  private
  def generate_token
    rand(1000..9999)
  end
end
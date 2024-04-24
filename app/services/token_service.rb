module TokenService

  def find_token(token:, user_id:)
    token = Token.find_by(token:, user_id:)
    return unless token

    expired = token.expires_at > Time.now
    return if expired

    token
  end

  def update_token_status(token)
    # We can avoid querying the db for that token
    return unless token.is_a?(Token)
    token.update!(is_used: true)
  end
end
class ApplicationController < ActionController::Base

  def current_user
    hmac_secret = ENV['SECRET_KEY']
    token = request.headers['Authorization'].to_s.split(' ').last
    return unless token

    user_id = JWT.decode token, hmac_secret, false, { algorithm: 'HS256' }
    User.find(user_id[0])
  end
end

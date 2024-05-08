class ApplicationController < ActionController::Base
  include ErrorHandler

  private 
  def ensure_user_is_logged_in
    redirect_to new_user_session_path unless user_signed_in?
  end
end

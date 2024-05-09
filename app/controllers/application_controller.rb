class ApplicationController < ActionController::Base
  private

  def ensure_user_is_logged_in
    redirect_to new_user_session_path unless user_signed_in?
  end

  rescue_from ActiveRecord::RecordNotFound do
    flash[:alert] = "The requested resource could not be found"
    redirect_to root_path
  end

  rescue_from ActiveRecord::RecordInvalid do |e|
    render flash[:alert] = e.record.errors
  end
end

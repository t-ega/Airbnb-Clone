class TokenMailer < ApplicationMailer
  default from: "airbnb-clone.clone"

  def reset_password
    @user = params[:user]
    @token = params[:token]
    mail(to: @user.email, subject: 'Reset password token')
  end

  def confirm_email
    @user = params[:user]
    @token = params[:token]
    mail(to: @user.email, subject: 'Email Confirmation token')
  end
end

module Accounts
  class CreateSubAccountService < ApplicationService
    def initialize(host_id)
      secret_key = ENV["QUIDAX_SECRET_KEY"]
      @quidax_object = Quidax.new(secret_key)
      @quidax_user = QuidaxUser.new(@quidax_object)
      @host_id = host_id
    end

    def call
      host = User.find(@host_id)
      return if host.nil?

      sub_account = QuidaxSubAccount.find_by_user_id(@host_id)
      return sub_account if sub_account

      begin
        res =
          @quidax_user.create_sub_account(
            body: {
              email: host.email,
              first_name: host.first_name,
              last_name: host.last_name,
              phone_number: ""
            }
          )
        data = res[:data]
      rescue QuidaxServerError => e
        # TODO: Store error in a log file
        # N.B: This is not an error that should halt the progress of the system
        puts e.response
        Rails.logger.error(e.response.body)
        return
      end

      # emails can be changed in our system, but the emails in a sub account cannot be changed, we need
      # to keep track of the email that was used when creating the sub account.
      account =
        SubAccount.new(id: data[:id], email: data[:email], user_id: host.id)
      return account if account.save
    end
  end
end

class CreateSubAccountService < ApplicationService
  include QuidaxInitializer

  def initialize(host_id)
    @quidax_user = QuidaxUser.new(self.class.quidax_object)
    @host_id = host_id
  end

  # Create a sub account on quidax for that particular host.
  # If a sub account already exits then return it
  def call
    sub_account = QuidaxSubAccount.find_by_user_id(@host_id)
    return sub_account if sub_account

    host = User.find(@host_id)

    begin
      res =
        @quidax_user.create_sub_account(
          body: {
            email: Faker::Internet.email,
            first_name: host.first_name,
            last_name: host.last_name,
            phone_number: ""
          }
        )
    rescue QuidaxServerError => e
      # TODO: Store error in a log file
      # N.B: This is not an error that should halt the progress of the system
      Rails.logger.error(e.response.body)
      return
    end

    data = res.with_indifferent_access

    QuidaxSubAccount.create!(id: data[:id], user_id: host.id)
  end
end

require 'rails_helper'

RSpec.describe "Reset password", type: :request do
  describe ".resolve" do

    it "should queue the reset password mail with the right data" do
      email = Faker::Internet.email
      password = Faker::Internet.password

      FactoryBot.create(:user,
                        first_name: Faker::Name.first_name,
                        last_name: Faker::Name.last_name,
                        email: email,
                        password: password ,
                        password_confirmation: password,
                        )

      expect do
        post "/graphql", params: {query: query(email)}
      end.to have_enqueued_job(ActionMailer::MailDeliveryJob)

      json = JSON.parse(response.body)
      error = json["errors"]

      expect(error).to be_nil

    end

    def query(email)
      <<~GQL
        mutation {
          resetPasswordMutation(
            email: "#{email}"
          ) {
              message
          }
        }
      GQL
    end

  end

end
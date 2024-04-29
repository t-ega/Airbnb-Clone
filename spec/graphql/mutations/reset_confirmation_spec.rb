require 'rails_helper'

RSpec.describe "Reset confirmation", type: :request do

  describe ".resolve" do

    it "should reset the user's password successfully" do
      email = Faker::Internet.email
      password = Faker::Internet.password
      token = double("token")
      user = FactoryBot.create(:user, first_name: Faker::Name.first_name,
                        last_name: Faker::Name.last_name,
                        email: email,
                        password: password ,
                        password_confirmation: password,
                        )

      allow(TokenService).to receive(:find_token).and_return(token)
      allow(TokenService).to receive(:update_token_status)
      new_password = "new_password"

      reset_params = {
        "email": email,
        "token": "1234",
        "password": new_password,
        "password_confirmation": new_password
      }

      post "/graphql", params: { query: query(**reset_params) }
      json = JSON.parse(response.body)
      data = json.dig('data', "resetConfirmationMutation", "message")
      error = json["errors"]

      expect(data).to be_present
      expect(error).to be_nil

      # Pull new data
      user.reload

      expect(user.valid_password?(new_password)).to be_truthy
      expect(TokenService).to have_received(:find_token)
    end

      def query(**args)
        email = args[:email]
        token = args[:token]
        password =  args[:password]
        password_confirmation = args[:password_confirmation]

        <<~GQL
          mutation {
            resetConfirmationMutation(
              email: "#{email}",
              password: "#{password}",
              passwordConfirmation: "#{password_confirmation}"
              token: "#{token}"
            ) {
                message
            }
          }
        GQL
      end
  end
end
require "rails_helper"

module Mutations
  RSpec.describe "Login", type: :request do
    describe ".resolve" do
      it "should login a user successfully" do
        password = Faker::Internet.password
        email = Faker::Internet.email
        FactoryBot.create(
          :user,
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          email: email,
          password: password,
          dob: Faker::Date.birthday(min_age: 18),
          password_confirmation: password,
          confirmed_at: Time.zone.now
        )

        sign_in_params = { email: email, password: password }

        post "/graphql", params: { query: query(**sign_in_params) }

        json = JSON.parse(response.body)
        data = json.dig("data", "signInMutation", "token")
        error = json["errors"]

        expect(data).to be_present
        expect(error).to be_nil
      end

      it "should fail if the user data is incorrect" do
        password = Faker::Internet.password
        email = Faker::Internet.email
        FactoryBot.create(
          :user,
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          email: email,
          password: password,
          password_confirmation: password
        )

        sign_in_params = { email: email, password: "wrong password" }

        post "/graphql", params: { query: query(**sign_in_params) }

        json = JSON.parse(response.body)
        data = json.dig("data", "loginMutation", "user")
        error = json["errors"]

        expect(data).to be_nil
        expect(error).to be_present
      end

      it "should include a falsy confirmation status" do
        password = Faker::Internet.password
        email = Faker::Internet.email

        FactoryBot.create(
          :user,
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          email: email,
          password: password,
          password_confirmation: password
        )

        sign_in_params = { email: email, password: password }

        post "/graphql", params: { query: query(**sign_in_params) }

        json = JSON.parse(response.body)
        data = json.dig("data", "signInMutation", "confrimed")
        error = json["errors"]

        expect(data).to be_falsy
        expect(error).to be_nil
      end
    end

    def query(**args)
      email = args[:email]
      password = args[:password]

      <<~GQL
        mutation {
          signInMutation(
            input: { email: "#{email}",
            password: "#{password}",
    }
          ) {
           token
          }
        }
      GQL
    end
  end
end

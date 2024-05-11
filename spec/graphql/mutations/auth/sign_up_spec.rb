require "rails_helper"

module Mutations
  RSpec.describe "Sign Up", type: :request do
    describe ".resolve" do
      it "should sign up a user successfully" do
        password = Faker::Internet.password
        user_params = {
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          email: Faker::Internet.email,
          password: password,
          dob: Faker::Date.birthday(min_age: 18),
          password_confirmation: password
        }

        expect do
          post "/graphql", params: { query: query(**user_params) }
        end.to change { User.count }.by(1)

        json = JSON.parse(response.body)
        data = json.dig("data", "signUpMutation", "user")
        error = json["errors"]

        expect(data).to_not be_nil
        expect(error).to be_nil

        user = User.find_by(email: user_params[:email])
        expect(user.confirmed_at).to be_nil

        expect(Devise.mailer.deliveries.count).to eq(1)
      end

      it "should fail if the user data is incomplete" do
        user_params = { first_name: Faker::Name.first_name }

        expect do
          post "/graphql", params: { query: query(**user_params) }
        end.to_not change { User.count }.from(0)

        json = JSON.parse(response.body)
        data = json.dig("data", "signUpMutation", "user")
        error = json["errors"]

        expect(data).to be_nil
        expect(error).to_not be_nil
      end

      it "should fail if a user with the same email exists" do
        password = Faker::Internet.password
        email = Faker::Internet.email

        FactoryBot.create(
          :user,
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          email: email,
          password: password,
          dob: Faker::Date.birthday(min_age: 18),
          password_confirmation: password
        )

        user_params = {
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          email: email,
          password: password,
          dob: Faker::Date.birthday(min_age: 18),
          password_confirmation: password
        }

        expect do
          post "/graphql", params: { query: query(**user_params) }
        end.to_not change { User.count }.from(1)

        error = response.body
        expect(error).to include("email")
      end
    end

    def query(**args)
      first_name = args[:first_name]
      last_name = args[:last_name]
      email = args[:email]
      password = args[:password]
      password_confirmation = args[:password_confirmation]
      dob = args[:dob]

      <<~GQL
        mutation {
          signUpMutation(
            input: {firstName: "#{first_name}",
            lastName: "#{last_name}",
            email: "#{email}",
            password: "#{password}",
            passwordConfirmation: "#{password_confirmation}"
            phoneNumber: "123456789"
            dob: "#{dob}"
    }
          ) {
           user {
              firstName
               lastName
            }

          }
        }
      GQL
    end
  end
end

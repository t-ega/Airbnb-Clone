# frozen_string_literal: true

module Mutations
  class SignInMutation < BaseMutation
    argument :email, String, required: true
    argument :password, String, required: true

    field :token, String, null: true
    field :error, String, null: true

    def resolve(email:, password:)
      raise GraphQL::ExecutionError, "User already signed in" if context[:current_user]

      hmac_secret = ENV["SECRET_KEY"]
      user = User.find_by(email: 'email')&.authenticate(password)

      raise GraphQL::ExecutionError, 'Email or Password is incorrect' unless user

      token = JWT.encode user.id, hmac_secret, 'HS256'
      {
        token: token,
        error: ''
      }
    end
  end
end

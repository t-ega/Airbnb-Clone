# frozen_string_literal: true

module Mutations
  module Auth
  class SignInMutation < BaseMutation
    argument :email, String, required: true
    argument :password, String, required: true

    field :token, String, null: true

    def resolve(email:, password:)
      raise GraphQL::ExecutionError, "User already signed in" if context[:current_user]

      hmac_secret = ENV["SECRET_KEY"]
      user = User.find_by(email:)

      raise GraphQL::ExecutionError, 'Email or Password is incorrect' unless user
      raise GraphQL::ExecutionError, 'Email or Password is incorrect' unless user.valid_password?(password)

      token = JWT.encode user.id, hmac_secret, 'HS256'
      {
        token: token,
      }
    end
  end
  end
end

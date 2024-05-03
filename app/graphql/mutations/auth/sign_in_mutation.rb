# frozen_string_literal: true

module Mutations
  module Auth
  class SignInMutation < BaseMutation
    include AuthService
    argument :email, String, required: true
    argument :password, String, required: true

    field :token, String, null: true

    def resolve(email:, password:)
      raise GraphQL::ExecutionError, "User already signed in" if context[:current_user]
      user = User.find_for_database_authentication(email:)

      raise GraphQL::ExecutionError, 'Email or Password is incorrect' unless user
      raise GraphQL::ExecutionError, 'Email or Password is incorrect' unless user.valid_password?(password)
      raise GraphQL::ExecutionError, "User not yet verified" unless user.confirmed_at.present?

      token = sign_user(user:)

      {
        token: token,
      }
    end

  end
  end
end

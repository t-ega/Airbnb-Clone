# frozen_string_literal: true

module Mutations
  module Auth
  class SignInMutation < BaseMutation

    argument :email, String, required: true
    argument :password, String, required: true

    field :token, String, null: true

    def resolve(email:, password:)
      raise GraphQL::ExecutionError, "User already signed in" if context[:current_user]
      user = User.find_for_database_authentication(email:)

      raise GraphQL::ExecutionError.new('Email or Password is incorrect', extensions: {code: ErrorCodes.invalid_credentials}) unless user
      raise GraphQL::ExecutionError.new('Email or Password is incorrect', extensions: {code: ErrorCodes.invalid_credentials}) unless user.valid_password?(password)
      raise GraphQL::ExecutionError.new("User not yet verified", extensions: {code: ErrorCodes.inactive_account}) unless user.confirmed_at.present?

      token = AuthService.sign_user(user)

      {
        token: token,
      }
    end

  end
  end
end

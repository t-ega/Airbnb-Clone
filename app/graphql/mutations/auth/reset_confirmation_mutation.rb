# frozen_string_literal: true

module Mutations
  module Auth
    class ResetConfirmationMutation < BaseMutation

      field :status, String, null: false
      field :message, String, null: false

      argument :email, String, required: true
      argument :token, String, required: true
      argument :password, String, required: true
      argument :password_confirmation, String, required: true

      def resolve(email:, token:, password:, password_confirmation:)
        raise GraphQL::ExecutionError, "Password cannot be blank" unless password.present?

        user = User.find_by(email:)
        raise GraphQL::ExecutionError, "User with that email doesn't exist" unless user

        token = TokenService.find_token(token: , user_id: user.id, purpose: TokenService::Purpose::RESET)
        raise GraphQL::ExecutionError, "Token expired or invalid" unless token

        match = (password == password_confirmation)
        raise GraphQL::ExecutionError, "Password and confirmation passwords dont match" unless match
        TokenService.update_token_status(token)

        success = user.reset_password(password, password_confirmation)
        raise GraphQL::ExecutionError, "Unable to reset password" unless success

        {status: "success", message: "Password reset successful"}
      end
    end
  end
end

# frozen_string_literal: true

module Mutations
  module Auth
    class ConfirmationMutation < BaseMutation

      field :status, String, null: false
      field :message, String, null: false

      argument :token, String, required: true
      argument :user_id, String, required: true

      def resolve(token:, user_id:)

        token = TokenService.find_token(token:, user_id:, purpose: Purpose::CONFIRMATION)
        raise GraphQL::ExecutionError, "Token invalid or expired" unless token

        user = User.find(user_id)
        return {status: :error, message: "User with specified id doesn't exist"} unless user

        user.update(confirmed_at: Time.now) unless user.confirmed_at

        TokenService.update_token_status(token)
        {status: :success, message: "User successfully verified!"}
      end
    end
  end
end

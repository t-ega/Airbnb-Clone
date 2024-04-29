# frozen_string_literal: true

module Mutations
  module Auth
    class ResetPasswordMutation < BaseMutation

      field :status, String, null: true
      field :message, String, null: true

      argument :email, String, required: true

      def resolve(email:)
        user = User.find_by(email:)
        raise GraphQL::ExecutionError, "Email doesn't exist" unless user

        expires_at = 1.hour.from_now
        token = TokenService.create_token(user_id: user.id, expires_at:, purpose: TokenService::Purpose::RESET)

        TokenMailer.with(user:, token: token.token).reset_password.deliver_later
        {status: "success", message: "Reset Token sent."}
      end
    end
  end
end

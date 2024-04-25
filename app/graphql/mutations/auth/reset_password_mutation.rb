# frozen_string_literal: true

module Mutations
  module Auth
    class ResetPasswordMutation < BaseMutation
      include TokenService

      field :status, String, null: true
      field :message, String, null: true

      argument :email, String, required: true

      def resolve(email:)
        user = User.find_by(email:)
        raise GraphQL::ExecutionError, "Email doesn't exist" unless user

        expires_at = 1.hour.from_now
        t = create_token(user.id, expires_at, Purpose::RESET)

        # TODO: Implement actual sending of the token
        {status: "success", message: "Reset Token sent. #{t.token}"}
      end
    end
  end
end

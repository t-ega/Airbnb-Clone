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
        AuthService.send_reset_instructions(user)
        {status: "success", message: "Reset Token sent."}
      end
    end
  end
end

# frozen_string_literal: true

module Mutations
  module Auth
    class SignOutMutation < BaseMutation

      field :status, String, null: true
      field :error, String, null: true

      def resolve(**args)
        raise GraphQL::ExecutionError.new("User not signed in", extensions: {code: ErrorCodes.unauthorized}) unless context[:current_user]

        token = authorization_token(context[:request])
        record = AuthService.destroy_token_session(token)

        raise GraphQL::ExecutionError.new('Email or Password is incorrect', extensions: {code: ErrorCodes.invalid_credentials}) unless record.present?
        { status: "Success" }
      end

      private
      def authorization_token(request)
        request.headers['Authorization'].to_s.split(' ').last
      end
    end
    end
end

# frozen_string_literal: true

module Mutations
  module Auth
    class SignOutMutation < BaseMutation
      include JwtService

      field :status, String, null: true
      field :error, String, null: true

      def resolve(**args)
        raise GraphQL::ExecutionError, "User not signed in" unless context[:current_user]

        token = authorization_token(context[:request])
        record = sign_out_user(token)

        raise GraphQL::ExecutionError, "User not signed in" unless record.present?
        { status: "Success" }
      end

      private
      def authorization_token(request)
        request.headers['Authorization'].to_s.split(' ').last
      end
    end
    end
end

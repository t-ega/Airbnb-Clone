# frozen_string_literal: true

module Mutations
  module Auth
    class SignOutMutation < BaseMutation
      field :status, String, null: true
      field :error, String, null: true

      def resolve(**args)
        authenticate_user!
        token = authorization_token(context[:request])
        record = AuthService.destroy_token_session(token)

        # If the record is nil it might be that the token just expired
        # or the session was deleted.
        if record.nil?
          raise GraphQL::ExecutionError.new(
                  "Unable to log out user",
                  extensions: {
                    code: ErrorCodes.internal_server
                  }
                )
        end
        { status: "Success" }
      end

      private

      def authorization_token(request)
        request.headers["Authorization"].to_s.split(" ").last
      end
    end
  end
end

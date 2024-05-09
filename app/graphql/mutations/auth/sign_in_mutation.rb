# frozen_string_literal: true

module Mutations
  module Auth
    class SignInMutation < BaseMutation
      argument :email, String, required: true
      argument :password, String, required: true

      field :token, String, null: true
      field :confirmed, Boolean, null: true

      def resolve(email:, password:)
        user = User.find_for_database_authentication(email:)

        unless user
          raise GraphQL::ExecutionError.new(
                  "Email or Password is incorrect",
                  extensions: {
                    code: ErrorCodes.invalid_credentials
                  }
                )
        end
        unless user.valid_password?(password)
          raise GraphQL::ExecutionError.new(
                  "Email or Password is incorrect",
                  extensions: {
                    code: ErrorCodes.invalid_credentials
                  }
                )
        end

        token = AuthService.sign_user(user)

        { token: token, confirmed: user.confirmed_at.present? }
      end
    end
  end
end

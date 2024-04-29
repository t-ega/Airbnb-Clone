# frozen_string_literal: true

module Mutations
  module Auth
  class SignUpMutation < BaseMutation

    field :user, Types::UserType
    field :message, String, null: true

    argument :first_name, String, required: true
    argument :last_name, String, required: true
    argument :email, String, required: true
    argument :password, String, required: true
    argument :password_confirmation, String, required: true
    argument :dob, GraphQL::Types::ISO8601Date, required: true
    argument :phone_number, String, required: true


    def resolve(**args)
      user = User.new(args)
      if user.save
        expires_at = 1.hour.from_now
        token = TokenService.create_token(user_id: user.id, expires_at:, purpose: TokenService::Purpose::CONFIRMATION)
        TokenMailer.with(user:, token:token.token).confirm_email.deliver_later
        { user:, message: "Created successfully. Check email for token" }
      else
        raise GraphQL::ExecutionError, user.errors.as_json.stringify_keys!
      end
    end
  end
  end
end

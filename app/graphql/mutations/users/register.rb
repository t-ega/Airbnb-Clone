# frozen_string_literal: true

module Mutations
  module Users
    class Register < BaseMutation
      argument :first_name, String, required:true
      argument :last_name, String, required:true
      argument :email, String, required:true
      argument :phone_number, String, required:true
      argument :password, String, required: true
      argument :password_confirmation, String, required: true
      argument :dob, GraphQL::Types::ISO8601Date, required:true

      type Types::UserType

      def resolve(**args)
        user = User.new(args)
        if user.save
          user
        else
          raise GraphQL::ExecutionError, user.errors.as_json.stringify_keys
        end
      end

    end
  end
end


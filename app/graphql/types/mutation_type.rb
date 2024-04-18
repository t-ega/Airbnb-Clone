# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    # TODO: remove me
    field :user, Types::UserType, null: false,
      description: "Mutation for a user object" do
      argument :first_name, String, required:true
      argument :last_name, String, required:true
      argument :email, String, required:true
    end

    def user(first_name:, last_name:, email:)
      user = User.new(first_name:first_name, last_name:last_name, email: email)
      if user.save
        user
      else
        GraphQL::ExecutionError.new(user.errors.full_messages)
      end

    end

  end
end

# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    # TODO: remove me
    field :user, Types::UserType, null: false,
      description: "Mutation for a user object" do
      argument :first_name, String, required:true
      argument :last_name, String, required:true
    end

    def user(first_name:, last_name:)
      user = User.new(first_name:last_name, last_name:last_name)
      if user.save
        user
      else
        raise GraphQL::ExecutionError.new(user.errors)
      end

    end

  end
end

# frozen_string_literal: true

module Mutations
  class BaseMutation < GraphQL::Schema::RelayClassicMutation
    null false

    private

    def authenticate_user!
      if context[:current_user].blank?
        raise GraphQL::ExecutionError.new(
                "Authentication failed, you must provide a valid token!",
                extensions: {
                  code: ErrorCodes.unauthorized
                }
              )
      end
      @current_user = context[:current_user]
    end
  end
end

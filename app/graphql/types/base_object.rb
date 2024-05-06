# frozen_string_literal: true

module Types
  class BaseObject < GraphQL::Schema::Object
    edge_type_class(Types::BaseEdge)
    connection_type_class(Types::BaseConnection)
    field_class Types::BaseField

    private

    def authenticate_user!
      if context[:current_user].blank?
        raise GraphQL::ExecutionError.new("Authentication failed, you must provide a valid token!", extensions: { code: ErrorCodes.unauthorized })
      end
    end
  end
end

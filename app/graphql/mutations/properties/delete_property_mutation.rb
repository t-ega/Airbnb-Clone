# frozen_string_literal: true

module Mutations
  module Properties
    class DeletePropertyMutation < BaseMutation
      argument :id, ID, required: true

      field :status, Types::ResponseStatusType

      def resolve(id:)
        authenticate_user!

        # Any property updated from the graphql endpoint might need to upload the image
        # to a prodiver like S3 and then return the url.
        property = Property.find(id)

        # Only host is allowed to update a property
        unless property.host == @current_user
          raise GraphQL::ExecutionError.new(
                  "Not allowed",
                  extensions: {
                    code: ErrorCodes.forbidden
                  }
                )
        end

        property.destroy

        unless property.persisted?
          return { property: property, status: :success }
        end

        raise GraphQL::ExecutionError.new(
                property.errors.as_json,
                extensions: {
                  code: ErrorCodes.unprocessable_entity
                }
              )
      end
    end
  end
end

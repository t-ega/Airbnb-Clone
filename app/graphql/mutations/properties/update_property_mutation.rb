# frozen_string_literal: true

module Mutations
  module Properties
    class UpdatePropertyMutation < BaseMutation
      argument :id, ID, required: true
      argument :name, String, required: false
      argument :headline, String, required: false
      argument :description, String, required: false
      argument :city, String, required: false
      argument :state, String, required: false
      argument :country, String, required: false
      argument :address, String, required: false
      argument :image_url, String, required: false
      argument :price, Float, required: false

      field :property, Types::PropertyType
      field :status, Types::ResponseStatusType

      def resolve(id:, **args)
        authenticate_user!
        # Any property updated from the graphql endpoint might need to upload the image
        # to a prodiver like S3 and then return the url.
        property = Property.find_by_id_and_host_id(id, @current_user)
        if property.nil?
          raise GraphQL::ExecutionError.new(
                  "The requested resource could not be found",
                  extensions: {
                    code: ErrorCodes.not_found
                  }
                )
        end

        property.update(**args)

        if property.save
          { property: property, status: :success }
        else
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
end

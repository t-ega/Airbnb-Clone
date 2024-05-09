# frozen_string_literal: true

module Mutations
  module Properties
    class CreatePropertyMutation < BaseMutation
      argument :name, String, required: true
      argument :headline, String, required: true
      argument :description, String, required: true
      argument :city, String, required: true
      argument :state, String, required: true
      argument :country, String, required: true
      argument :address, String, required: true
      argument :price, Float, required: true

      field :property, Types::PropertyType
      field :status, Types::ResponseStatusType

      def resolve(
        name:,
        headline:,
        description:,
        address:,
        city:,
        price:,
        state:,
        country:
      )
        authenticate_user!
        # Any property uploaded from the graphql endpoint would need to upload the image
        # to a prodiver like S3 and then return the url. The caveat to this is that after the image has been
        # uploaded, if the property fails to be created then the image is of no use.
        # The suggested way to do this is to upload the image from the webview.
        property =
          Property.new(
            name:,
            headline:,
            description:,
            address:,
            city:,
            price:,
            host: @current_user,
            state:,
            country:
          )

        return { property: property, status: :success } if property.save

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

# frozen_string_literal: true

module Mutations
  module Properties
    class PropertyMutation < BaseMutation
      argument :name, String, required: true
      argument :headline, String, required: true
      argument :description, String, required: true
      argument :city, String, required: true
      argument :state, String, required: true
      argument :country, String, required: true
      argument :address, String, required: true
      argument :host, Integer, required: true
      argument :price, Float, required: true

      field :property, Types::PropertyType
      field :status, Types::ResponseStatusType

      def resolve(name:, headline:, description:, address:, city:, price:, host:, state:, country:)
        authenticate_user!

        property = Property.new(name:, headline:, description:, address:, city:, price:, host_id:host, state:, country:)
        if property.save
          { property: property, status: :success }
        else
          raise GraphQL::ExecutionError.new(property.errors.as_json, extensions: {code: ErrorCodes.unprocessable_entity })
        end
      end

    end
  end
end

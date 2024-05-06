# frozen_string_literal: true

module Mutations
  module Properties
    class PropertyMutation < BaseMutation

      field :properties, [Types::PropertyType], null: false

      def properties
        Property.all
      end

      field [:property, Types::PropertyType], null: false do
        argument :id, ID, required: true
      end

      def property(id:)
        Property.find(id)
      end

    end
  end
end

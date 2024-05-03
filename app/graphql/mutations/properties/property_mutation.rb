# frozen_string_literal: true

module Mutations
  module Properties
    class PropertyMutation < BaseMutation
      field :properties, Types::PropertyType, null: false

      def properties
        {properties: Property.all}
      end

    end
  end
end

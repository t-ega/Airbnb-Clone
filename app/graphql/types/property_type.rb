# frozen_string_literal: true

module Types
  class PropertyType < Types::BaseObject
    field :id, ID, null: false
    field :title, String
    field :content, String
    field :rating, Integer
    field :reviewer, Types::UserType
    field :state, String, null: false
    field :address, String, null: false
    field :price, BigDecimal
    field :reviews, [Types::ReviewType]
    field :host, Types::UserType
    field :created_at,  GraphQL::Types::ISO8601DateTime
  end
end

# frozen_string_literal: true

module Types
  class PropertyType < Types::BaseObject
    field :id, ID, null: false
    field :name, String
    field :description, String
    field :headline, String
    field :city, String
    field :average_rating, Integer
    field :state, String, null: false
    field :address, String, null: false
    field :country, String, null: false
    field :price, Float
    field :reviews, [Types::ReviewType]
    field :host, Types::UserType
    field :created_at,  GraphQL::Types::ISO8601DateTime
  end
end

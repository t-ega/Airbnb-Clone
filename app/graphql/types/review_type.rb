# frozen_string_literal: true

module Types
  class ReviewType < Types::BaseObject
    field :id, ID, null: false
    field :title, String
    field :content, String
    field :rating, Integer
    field :reviewer, Types::UserType
    field :created_at,  GraphQL::Types::ISO8601DateTime
  end
end

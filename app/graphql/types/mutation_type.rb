# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject

    # ------------------
    # Users
    # ------------------
    field :register, mutation: Mutations::Users::Register
  end
end

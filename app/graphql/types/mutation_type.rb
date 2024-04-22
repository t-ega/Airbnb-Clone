# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :sign_in_mutation, mutation: Mutations::SignInMutation

    # ------------------
    # Users
    # ------------------
    field :register, mutation: Mutations::Users::Register
  end
end

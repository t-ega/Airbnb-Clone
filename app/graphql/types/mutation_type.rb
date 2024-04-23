# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :sign_out_mutation, mutation: Mutations::SignOutMutation

    # ------------------
    # Users
    # ------------------
    field :sign_up_mutation, mutation: Mutations::Auth::SignUpMutation
    field :sign_in_mutation, mutation: Mutations::Auth::SignInMutation
  end
end

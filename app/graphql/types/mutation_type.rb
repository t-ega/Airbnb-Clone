# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject

    # ------------------
    # Auth
    # ------------------
    field :sign_up_mutation, mutation: Mutations::Auth::SignUpMutation
    field :sign_in_mutation, mutation: Mutations::Auth::SignInMutation
    field :sign_out_mutation, mutation: Mutations::Auth::SignOutMutation
    field :confirmation_mutation, mutation: Mutations::Auth::ConfirmationMutation


  end
end

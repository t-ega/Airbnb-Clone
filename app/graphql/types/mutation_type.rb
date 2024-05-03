# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    # field :property, mutation: Mutations::Properties::PropertyMutation

    # ------------------
    # Auth
    # ------------------
    field :sign_up_mutation, mutation: Mutations::Auth::SignUpMutation
    field :sign_in_mutation, mutation: Mutations::Auth::SignInMutation
    field :sign_out_mutation, mutation: Mutations::Auth::SignOutMutation
    field :confirmation_mutation, mutation: Mutations::Auth::ConfirmationMutation
    field :reset_confirmation_mutation, mutation: Mutations::Auth::ResetConfirmationMutation
    field :reset_password_mutation, mutation: Mutations::Auth::ResetPasswordMutation


  end
end

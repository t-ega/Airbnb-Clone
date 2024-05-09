# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    # ------------------
    # Auth
    # ------------------
    field :sign_up_mutation, mutation: Mutations::Auth::SignUpMutation
    field :sign_in_mutation, mutation: Mutations::Auth::SignInMutation
    field :sign_out_mutation, mutation: Mutations::Auth::SignOutMutation
    field :reset_password_mutation,
          mutation: Mutations::Auth::ResetPasswordMutation

    # -------------------
    # Properties
    # -------------------
    field :create_property,
          mutation: Mutations::Properties::CreatePropertyMutation
    field :update_property,
          mutation: Mutations::Properties::UpdatePropertyMutation
    field :destroy_property,
          mutation: Mutations::Properties::DeletePropertyMutation
  end
end

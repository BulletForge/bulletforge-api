# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    # Users
    field :create_user, mutation: Mutations::CreateUser
    field :update_user, mutation: Mutations::UpdateUser
    field :destroy_user, mutation: Mutations::DestroyUser

    # User Sessions
    field :login, mutation: Mutations::Login
    field :token_login, mutation: Mutations::TokenLogin
  end
end

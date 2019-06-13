# frozen_string_literal: true

module Mutations
  class CreateUser < Mutations::BaseMutation
    null true

    argument :login, String, required: true
    argument :email, String, required: true
    argument :password, String, required: true
    argument :passwordConfirmation, String, required: true

    field :user, Types::UserType, null: true

    def resolve(login:, email:, password:, password_confirmation:)
      user = User.create!(
        login: login,
        email: email,
        password: password,
        password_confirmation: password_confirmation
      )

      { user: user }
    rescue ActiveRecord::RecordInvalid => e
      raise GraphQL::ExecutionError, e.message
    end
  end
end

# frozen_string_literal: true

module Mutations
  class CreateUser < Mutations::BaseMutation
    null true

    argument :login, String, required: true
    argument :email, String, required: true
    argument :password, String, required: true
    argument :passwordConfirmation, String, required: true

    field :user, Types::UserType, null: true
    field :errors, [String], null: false

    def resolve(login:, email:, password:, password_confirmation:)
      user = User.new(
        login: login,
        email: email,
        password: password,
        password_confirmation: password_confirmation
      )

      if user.save
        { user: user, errors: [] }
      else
        { user: nil, errors: user.errors.full_messages }
      end
    end
  end
end

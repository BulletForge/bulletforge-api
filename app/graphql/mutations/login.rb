# frozen_string_literal: true

module Mutations
  class Login < Mutations::BaseMutation
    null true

    argument :login, String, required: true
    argument :password, String, required: true

    field :user, Types::UserType, null: true
    field :errors, [String], null: false

    def resolve(login:, password:)
      user = User.find_for_authentication(login: login)
      return nil unless user

      is_valid_for_auth = user.valid_for_authentication? do
        user.valid_password?(password)
      end

      if is_valid_for_auth
        # TODO: Actually provide a token or something
        { user: user, errors: [] }
      else
        { user: nil, errors: ['Invalid username or password.'] }
      end
    end
  end
end

# frozen_string_literal: true

module Mutations
  class Login < Mutations::BaseMutation
    null true

    argument :login, String, required: true
    argument :password, String, required: true

    field :token, String, null: true
    field :errors, [String], null: false

    def resolve(login:, password:)
      user = User.find_for_authentication(login: login)
      return nil unless user

      is_valid_for_auth = user.valid_for_authentication? do
        user.valid_password?(password)
      end

      if is_valid_for_auth
        token = JsonWebToken.encode(user_id: user.id)
        { token: token, errors: [] }
      else
        { token: nil, errors: ['Invalid username or password.'] }
      end
    end
  end
end

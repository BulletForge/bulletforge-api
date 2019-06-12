# frozen_string_literal: true

module Mutations
  class Login < Mutations::BaseMutation
    null true

    argument :login, String, required: true
    argument :password, String, required: true

    field :token, String, null: true

    def resolve(login:, password:)
      user = User.find_for_authentication(login: login)
      is_valid_for_auth = user&.valid_for_authentication? do
        user.valid_password?(password)
      end
      raise GraphQL::ExecutionError, 'Invalid username/password combination' unless is_valid_for_auth

      { token: JsonWebToken.encode(user_id: user.id) }
    end
  end
end

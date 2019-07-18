# frozen_string_literal: true

module Mutations
  class Login < Mutations::BaseMutation
    null true

    argument :login, String, required: true
    argument :password, String, required: true

    field :token, String, null: true
    field :errors, [Types::UserErrorType], null: false

    def resolve(login:, password:)
      user = User.find_for_authentication(login: login)

      if valid_for_auth?(user, password)
        success_response(user)
      else
        add_error([], 'Invalid username/password combination')
        error_response
      end
    end

    private

    def valid_for_auth?(user, password)
      user&.valid_for_authentication? do
        user.valid_password?(password)
      end
    end

    def success_response(user)
      {
        token: JsonWebToken.encode(user_id: user.id),
        errors: []
      }
    end

    def error_response
      {
        token: nil,
        errors: user_errors
      }
    end
  end
end

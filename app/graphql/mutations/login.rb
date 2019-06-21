# frozen_string_literal: true

module Mutations
  class Login < Mutations::BaseMutation
    null true

    argument :login, String, required: false
    argument :password, String, required: false

    field :token, String, null: true
    field :errors, [Types::UserErrorType], null: false

    def ready?(**args)
      required = %i[login password]
      required_arguments(args: args, required: required, on_error: { token: nil })
    end

    def resolve(login:, password:)
      user = User.find_for_authentication(login: login)
      is_valid_for_auth = user&.valid_for_authentication? do
        user.valid_password?(password)
      end

      if is_valid_for_auth
        {
          token: JsonWebToken.encode(user_id: user.id),
          errors: []
        }
      else
        {
          token: nil,
          errors: login_errors
        }
      end
    end

    def login_errors
      [
        {
          path: [],
          message: 'Invalid username/password combination'
        }
      ]
    end
  end
end

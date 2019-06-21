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
      required_arguments(args: args, required: required)

      super(**args)
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
        user_errors << login_error
        error_response
      end
    end

    private

    def error_response
      { token: nil }.merge(super)
    end

    def login_error
      {
        path: [],
        message: 'Invalid username/password combination'
      }
    end
  end
end

# frozen_string_literal: true

module Mutations
  class UpdateMe < Mutations::BaseMutation
    null true

    argument :login, String, required: false
    argument :email, String, required: false
    argument :password, String, required: false
    argument :password_confirmation, String, required: false

    field :user, Types::UserType, null: true
    field :errors, [Types::UserErrorType], null: false

    def ready?(**args)
      require_login
      super(**args)
    end

    def resolve(**args)
      user = context[:current_user]

      if user.update(args)
        success_response(user)
      else
        add_model_errors(user)
        error_response
      end
    end

    private

    def success_response(user)
      {
        user: user,
        errors: []
      }
    end

    def error_response
      {
        user: nil,
        errors: user_errors
      }
    end
  end
end

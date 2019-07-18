# frozen_string_literal: true

module Mutations
  class UpdateUser < Mutations::BaseMutation
    null true

    argument :user_id, ID, required: true, loads: Types::UserType
    argument :login, String, required: false
    argument :email, String, required: false
    argument :admin, Boolean, required: false
    argument :password, String, required: false
    argument :password_confirmation, String, required: false

    field :user, Types::UserType, null: true
    field :errors, [Types::UserErrorType], null: false

    def ready?(**args)
      require_login
      super(**args)
    end

    def authorized?(**args)
      authorize UpdateUserPolicy.new(current_user)
      super(**args)
    end

    def resolve(user:, **args)
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

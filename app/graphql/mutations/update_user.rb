# frozen_string_literal: true

module Mutations
  class UpdateUser < Mutations::BaseMutation
    null true

    argument :user_id, ID, required: false, loads: Types::UserType
    argument :login, String, required: false
    argument :email, String, required: false
    argument :admin, Boolean, required: false
    argument :password, String, required: false
    argument :password_confirmation, String, required: false

    field :user, Types::UserType, null: true
    field :errors, [Types::UserErrorType], null: false

    def ready?(**args)
      continue, error_response = require_login(on_error: { success: false })
      return false, error_response unless continue

      # user_id arg is removed when converted to user
      required = %i[user]
      required_arguments(args: args, required: required, on_error: { success: false })
    end

    def authorized?(**_args)
      policy = UpdateUserPolicy.new(context[:current_user])
      authorize policy
    end

    def resolve(user:, **args)
      if user.update(args)
        {
          user: user,
          errors: []
        }
      else
        {
          user: nil,
          errors: build_errors(user)
        }
      end
    end

    private

    def build_errors(user)
      user.errors.map do |attribute, message|
        attribute = attribute.to_s.camelize(:lower)
        {
          path: ['input', attribute.to_s.camelize(:lower)],
          message: attribute + ' ' + message
        }
      end
    end
  end
end

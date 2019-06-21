# frozen_string_literal: true

module Mutations
  class DestroyUser < Mutations::BaseMutation
    null true

    argument :user_id, ID, required: false, loads: Types::UserType

    field :success, Boolean, null: true
    field :errors, [Types::UserErrorType], null: false

    def ready?(**args)
      continue, error_response = require_login(on_error: { success: false })
      return false, error_response unless continue

      # user_id arg is removed when converted to user
      required = %i[user]
      required_arguments(args: args, required: required, on_error: { success: false })
    end

    def authorized?(**_args)
      policy = DestroyUserPolicy.new(context[:current_user])
      authorize(policy, on_error: { success: false })
    end

    def resolve(user:)
      user.destroy

      {
        success: true,
        errors: []
      }
    end
  end
end

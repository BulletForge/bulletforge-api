# frozen_string_literal: true

module Mutations
  class DestroyUser < Mutations::BaseMutation
    null true

    argument :user_id, ID, required: false, loads: Types::UserType

    field :success, Boolean, null: true
    field :errors, [Types::UserErrorType], null: false

    def ready?(**args)
      require_login

      # user_id arg is removed when converted to user
      required = %i[user]
      required_arguments(args: args, required: required)

      super(**args)
    end

    def authorized?(**args)
      authorize DestroyUserPolicy.new(context[:current_user])
      super(**args)
    end

    def resolve(user:)
      user.destroy

      {
        success: true,
        errors: []
      }
    end

    private

    def error_response
      { success: false }.merge(super)
    end
  end
end

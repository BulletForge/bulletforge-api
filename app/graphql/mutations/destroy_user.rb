# frozen_string_literal: true

module Mutations
  class DestroyUser < Mutations::BaseMutation
    null true

    argument :user_id, ID, required: true, loads: Types::UserType

    field :success, Boolean, null: true
    field :errors, [Types::UserErrorType], null: false

    def ready?(**args)
      require_login
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

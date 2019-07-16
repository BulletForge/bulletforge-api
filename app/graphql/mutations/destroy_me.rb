# frozen_string_literal: true

module Mutations
  class DestroyMe < Mutations::BaseMutation
    null true

    field :success, Boolean, null: true
    field :errors, [Types::UserErrorType], null: false

    def ready?(**args)
      require_login
      super(**args)
    end

    def resolve
      context[:current_user].destroy
      success_response
    end

    private

    def success_response
      {
        success: true,
        errors: []
      }
    end

    def error_response
      {
        success: false,
        errors: user_errors
      }
    end
  end
end

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

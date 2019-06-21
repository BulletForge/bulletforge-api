# frozen_string_literal: true

module Mutations
  class DestroyMe < Mutations::BaseMutation
    null true

    field :success, Boolean, null: true

    def ready?(**_args)
      require_login
      true
    end

    def resolve
      context[:current_user].destroy

      { success: true }
    end
  end
end

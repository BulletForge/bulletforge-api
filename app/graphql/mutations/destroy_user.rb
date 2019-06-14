# frozen_string_literal: true

module Mutations
  class DestroyUser < Mutations::BaseMutation
    null true

    argument :user_id, ID, required: true, loads: Types::UserType

    field :success, Boolean, null: true

    def ready?(**_args)
      require_login
      true
    end

    def authorized?(user:)
      authorize(DestroyUserPolicy.new(context[:current_user], user))
      true
    end

    def resolve(user:)
      user.destroy

      { success: true }
    end
  end
end

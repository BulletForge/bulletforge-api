# frozen_string_literal: true

module Mutations
  class BaseMutation < GraphQL::Schema::RelayClassicMutation
    private

    def require_login
      load_current_user
      raise GraphQL::ExecutionError, require_login_message unless context[:current_user]
    end

    def authorize(policy)
      raise GraphQL::ExecutionError, unauthorized_message unless policy.authorized?
    end

    def require_login_message
      'You must be logged in to perform this action'
    end

    def unauthorized_message
      'You do not have permission to perform this action'
    end

    def load_current_user
      return if context[:current_user] || !context[:current_user_id]

      context[:current_user] = User.find(context[:current_user_id])
    end
  end
end

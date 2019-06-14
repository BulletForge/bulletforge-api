# frozen_string_literal: true

module Mutations
  class BaseMutation < GraphQL::Schema::RelayClassicMutation
    private

    def require_login
      raise GraphQL::ExecutionError, require_login_message unless context[:current_user]
    end

    def authorize(policy)
      raise GraphQL::ExecutionError, unauthorized_message unless policy.authorized?
    end

    def require_login_message
      'You must be logged in to peform this action'
    end

    def unauthorized_message
      'You do not have permission to perform this action'
    end
  end
end

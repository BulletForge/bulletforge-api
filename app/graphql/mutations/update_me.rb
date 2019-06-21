# frozen_string_literal: true

module Mutations
  class UpdateMe < Mutations::BaseMutation
    null true

    argument :login, String, required: false
    argument :email, String, required: false
    argument :password, String, required: false
    argument :passwordConfirmation, String, required: false

    field :user, Types::UserType, null: true

    def ready?(**_args)
      require_login
      true
    end

    def resolve(**args)
      user = context[:current_user]
      user.update!(args)

      { user: user }
    rescue ActiveRecord::RecordInvalid => e
      raise GraphQL::ExecutionError, e.message
    end
  end
end

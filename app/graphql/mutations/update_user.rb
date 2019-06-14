# frozen_string_literal: true

module Mutations
  class UpdateUser < Mutations::BaseMutation
    null true

    argument :user_id, ID, required: true, loads: Types::UserType
    argument :login, String, required: false
    argument :email, String, required: false
    argument :admin, Boolean, required: false
    argument :password, String, required: false
    argument :passwordConfirmation, String, required: false

    field :user, Types::UserType, null: true

    def ready?(**_args)
      require_login
      true
    end

    def authorized?(user:, **args)
      authorize(UpdateUserPolicy.new(context[:current_user], user, args))
      true
    end

    def resolve(user:, **args)
      user.update!(args)

      { user: user }
    rescue ActiveRecord::RecordInvalid => e
      raise GraphQL::ExecutionError, e.message
    end
  end
end

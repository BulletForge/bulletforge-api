# frozen_string_literal: true

module Mutations
  class UpdateUser < Mutations::BaseMutation
    null true

    argument :id, ID, required: true
    argument :login, String, required: false
    argument :email, String, required: false
    argument :admin, Boolean, required: false
    argument :password, String, required: false
    argument :passwordConfirmation, String, required: false

    field :user, Types::UserType, null: true

    def ready?(**args)
      require_login

      policy = UserUpdatePolicy.new(context[:current_user], args)
      authorize(policy)

      true
    end

    def resolve(id:, **args)
      user = User.friendly.find id
      user.update!(args)

      { user: user }
    rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound => e
      raise GraphQL::ExecutionError, e.message
    end
  end
end

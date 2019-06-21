# frozen_string_literal: true

module Mutations
  class UpdateMe < Mutations::BaseMutation
    null true

    argument :login, String, required: false
    argument :email, String, required: false
    argument :password, String, required: false
    argument :password_confirmation, String, required: false

    field :user, Types::UserType, null: true
    field :errors, [Types::UserErrorType], null: false

    def ready?(**_args)
      require_login
    end

    def resolve(**args)
      user = context[:current_user]
      if user.update(args)
        {
          user: user,
          errors: []
        }
      else
        {
          user: nil,
          errors: build_errors(user)
        }
      end
    end

    private

    def build_errors(user)
      user.errors.map do |attribute, message|
        attribute = attribute.to_s.camelize(:lower)
        {
          path: ['input', attribute.to_s.camelize(:lower)],
          message: attribute + ' ' + message
        }
      end
    end
  end
end

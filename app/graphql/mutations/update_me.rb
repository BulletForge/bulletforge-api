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

    def ready?(**args)
      require_login
      super(**args)
    end

    def resolve(**args)
      user = context[:current_user]
      if user.update(args)
        {
          user: user,
          errors: []
        }
      else
        add_errors(user)
        error_response
      end
    end

    private

    def error_response
      { user: nil }.merge(super)
    end

    def add_errors(user)
      user.errors.each do |attribute, message|
        attribute = attribute.to_s.camelize(:lower)
        user_errors << {
          path: ['input', attribute.to_s.camelize(:lower)],
          message: attribute + ' ' + message
        }
      end
    end
  end
end

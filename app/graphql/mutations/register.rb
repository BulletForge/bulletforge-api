# frozen_string_literal: true

module Mutations
  class Register < Mutations::BaseMutation
    null true

    argument :login, String, required: true
    argument :email, String, required: true
    argument :password, String, required: true
    argument :password_confirmation, String, required: true

    field :user, Types::UserType, null: true
    field :errors, [Types::UserErrorType], null: false

    def resolve(login:, email:, password:, password_confirmation:)
      user = User.new(
        login: login,
        email: email,
        password: password,
        password_confirmation: password_confirmation
      )

      if user.save
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

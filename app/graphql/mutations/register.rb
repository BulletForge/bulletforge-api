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
      user = new_user(login, email, password, password_confirmation)

      if user.save
        success_response(user)
      else
        add_model_errors(user)
        error_response
      end
    end

    private

    def new_user(login, email, password, password_confirmation)
      User.new(
        login: login,
        email: email,
        password: password,
        password_confirmation: password_confirmation
      )
    end

    def success_response(user)
      {
        user: user,
        errors: []
      }
    end

    def error_response
      {
        user: nil,
        errors: user_errors
      }
    end
  end
end

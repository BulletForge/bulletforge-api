# frozen_string_literal: true

module Mutations
  class BaseMutation < GraphQL::Schema::RelayClassicMutation
    def ready?(**_args)
      continue?
    end

    def authorized?(**_args)
      continue?
    end

    private

    def continue?
      if user_errors.empty?
        true
      else
        [false, error_response]
      end
    end

    def require_login
      user_errors << require_login_error unless logged_in?
    end

    def required_arguments(args:, required:)
      required.each do |required_arg|
        user_errors << required_arg_error(required_arg) if args[required_arg].nil?
      end
    end

    def authorize(policy)
      user_errors << unauthorized_error unless policy.authorized?
    end

    def logged_in?
      load_current_user
      context[:current_user]
    end

    def load_current_user
      return if context[:current_user] || !context[:current_user_id]

      context[:current_user] = User.find(context[:current_user_id])
    end

    def user_errors
      return @user_errors if @user_errors

      @user_errors = []
    end

    def error_response
      {
        errors: user_errors
      }
    end

    def require_login_error
      {
        path: [],
        message: 'You must be logged in to perform this action.'
      }
    end

    def unauthorized_error
      {
        path: [],
        message: 'You are not authorized to perform this action.'
      }
    end
  end
end

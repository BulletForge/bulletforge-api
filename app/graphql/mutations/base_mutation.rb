# frozen_string_literal: true

module Mutations
  class BaseMutation < GraphQL::Schema::RelayClassicMutation
    private

    def require_login(on_error: {})
      if logged_in?
        true
      else
        on_error[:errors] = [require_login_error]
        [false, on_error]
      end
    end

    def required_arguments(args:, required:, on_error: {})
      errors = []
      required.each do |required_arg|
        errors << required_arg_error(required_arg) if args[required_arg].nil?
      end

      if errors.empty?
        true
      else
        on_error[:errors] = errors
        [false, on_error]
      end
    end

    def authorize(policy, on_error: {})
      if policy.authorized?
        true
      else
        on_error[:errors] = [unauthorized_error]
        [false, on_error]
      end
    end

    def logged_in?
      load_current_user
      context[:current_user]
    end

    def load_current_user
      return if context[:current_user] || !context[:current_user_id]

      context[:current_user] = User.find(context[:current_user_id])
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

    def required_arg_error(arg)
      arg = arg.to_s.camelize(:lower)
      {
        path: ['input', arg],
        message: arg + ' is a required input'
      }
    end
  end
end

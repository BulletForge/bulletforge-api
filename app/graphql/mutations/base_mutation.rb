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
      add_require_login_error unless current_user
    end

    def authorize(policy)
      add_unauthorized_error unless policy.authorized?
    end

    def current_user
      context[:current_user] || load_current_user
    end

    def load_current_user
      return unless context[:current_user_id]

      context[:current_user] = User.find(context[:current_user_id])
    end

    def add_model_errors(model)
      model.errors.each do |attribute, message|
        attr_str = attribute.to_s.camelize(:lower)

        path = ['input', attr_str]
        msg = attr_str + ' ' + message
        add_error(path, msg)
      end
    end

    def user_errors
      @user_errors ||= []
    end

    def add_error(path, message)
      user_errors << {
        path: path,
        message: message
      }
    end

    def add_require_login_error
      add_error([], 'You must be logged in to perform this action.')
    end

    def add_unauthorized_error
      add_error([], 'You are not authorized to perform this action.')
    end
  end
end

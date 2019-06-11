# frozen_string_literal: true

class GraphqlController < ApplicationController
  def execute
    context = {
      current_user: find_current_user
    }

    result = BulletforgeApiSchema.execute(
      params[:query],
      variables: ensure_hash(params[:variables]),
      context: context,
      operation_name: params[:operationName]
    )

    render json: result
  rescue StandardError => e
    raise e unless Rails.env.development?

    handle_error_in_development e
  end

  private

  # Devise provides current_user already, but doesn't recognize JWTs.
  # We can't use devise-jwt since there doesn't appear to be a way to
  # ask it to generate a token for us outside of logging in through
  # the Devise routes.
  def find_current_user
    auth_header = request.headers['Authorization']
    auth_header ||= request.cookies['_auth'] if Rails.env.development? # Dumb hack for graphiql-rails
    return unless auth_header

    auth_token = auth_header.split(' ').last
    decoded_json = JsonWebToken.decode(auth_token)

    User.find(decoded_json[:user_id]) if decoded_json
  end

  # Handle form data, JSON body, or a blank value
  def ensure_hash(ambiguous_param)
    case ambiguous_param
    when String
      if ambiguous_param.present?
        ensure_hash(JSON.parse(ambiguous_param))
      else
        {}
      end
    when Hash, ActionController::Parameters
      ambiguous_param
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{ambiguous_param}"
    end
  end

  def handle_error_in_development(err)
    logger.error err.message
    logger.error err.backtrace.join("\n")

    json = {
      error: {
        message: err.message,
        backtrace: err.backtrace
      },
      data: {}
    }

    render json: json, status: 500
  end
end

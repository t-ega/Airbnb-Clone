# frozen_string_literal: true

class GraphqlController < ApplicationController

  # I have modified the default way Graphql handles it errors
  # @see config/initializers/execution_error.rb
  def execute
    variables = prepare_variables(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]
    context = {
      current_user: current_user,
      request: request
    }
    result = AirbnbCloneSchema.execute(query, variables: variables, context: context, operation_name: operation_name)
    render json: { status: response_status(result.to_h), **result }
  rescue StandardError => e
    raise e unless Rails.env.development?
    handle_error_in_development(e)
  end

  private
  def authorization_token
    request.headers['Authorization'].to_s.split(' ').last
  end


  def current_user
    AuthService.current_user(authorization_token)
  end

  def response_status(result)
    return "success" unless result.is_a?(Hash)
    modified_keys = result.symbolize_keys
    modified_keys.fetch(:errors, nil).present? ? "error" : "success"
  end

  # Handle variables in form data, JSON body, or a blank value
  def prepare_variables(variables_param)
    case variables_param
    when String
      if variables_param.present?
        JSON.parse(variables_param) || {}
      else
        {}
      end
    when Hash
      variables_param
    when ActionController::Parameters
      variables_param.to_unsafe_hash # GraphQL-Ruby will validate name and type of incoming variables.
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{variables_param}"
    end
  end

  def handle_error_in_development(e)
    logger.error e.message
    logger.error e.backtrace.join("\n")

    render json: { status: "error", errors: [{ message: e.message, backtrace: e.backtrace }], data: {} }, status: 500
  end


end

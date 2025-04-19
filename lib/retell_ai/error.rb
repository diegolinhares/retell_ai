# frozen_string_literal: true

require 'securerandom'

module RetellAI
  # Base error class for all RetellAI errors
  class Error < StandardError
    attr_reader :type, :title, :status, :detail, :instance, :suggestion

    # Initializes a new Error instance
    # @param message [String, nil] Error message
    # @param error_details [Hash] Hash containing error details
    def initialize(message = nil, **error_details)
      @type = error_details[:type] || 'https://api.retell.ai/errors/unknown-error'
      @title = message || 'Unknown Error'
      @status = error_details[:status] || 500
      @detail = error_details[:detail] || message
      @instance = error_details[:instance]
      @suggestion = error_details[:suggestion]
      super(message)
    end

    def to_problem_details
      {
        type: @type,
        title: @title,
        status: @status,
        detail: @detail,
        instance: @instance,
        suggestion: @suggestion
      }.compact
    end
  end

  # Error raised when API credentials are invalid or missing
  class InvalidCredentialsError < Error
    def initialize(message = 'Missing or invalid API key')
      super(
        message,
        type: 'https://api.retell.ai/errors/invalid-credentials',
        status: 401,
        detail: 'The API key provided was missing or invalid',
        suggestion: "Check if you've set the correct API key or generate a new one from your Retell dashboard"
      )
    end
  end

  # Error raised when an invalid phone number is provided
  class InvalidPhoneNumberError < Error
    def initialize(param_name, number = nil)
      detail = "The #{param_name} provided (#{number}) is not a valid phone number"
      super(
        "Invalid #{param_name} format",
        type: 'https://api.retell.ai/errors/invalid-phone-number',
        status: 400,
        detail: detail,
        suggestion: 'Phone numbers must be in E.164 format (e.g., +14157774444)'
      )
    end
  end

  # Error raised when the API returns an error response
  class ApiError < Error
    def initialize(status, detail)
      super(
        "API Error (Status #{status})",
        type: 'https://api.retell.ai/errors/api-error',
        status: status,
        detail: detail,
        suggestion: 'Check the error details and adjust your request accordingly'
      )
    end
  end

  # Error raised when a network error occurs
  class NetworkError < Error
    def initialize(detail)
      super(
        'Network Error',
        type: 'https://api.retell.ai/errors/network-error',
        status: 503,
        detail: detail,
        suggestion: 'Check your network connection or try again later'
      )
    end
  end

  # Error raised when an unexpected error occurs
  class UnexpectedError < Error
    def initialize(message, original_error = nil)
      error_id = ::SecureRandom.uuid
      detail = original_error ? "#{message}: #{original_error.message}" : message

      super(
        'Unexpected error',
        type: 'https://api.retell.ai/errors/unexpected-error',
        status: 500,
        detail: detail,
        instance: "/errors/#{error_id}",
        suggestion: "Please contact support and reference error ID: #{error_id}"
      )
    end
  end
end

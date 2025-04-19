# frozen_string_literal: true

require 'singleton'

module RetellAI
  # API Client for RetellAI services
  class Client
    include Singleton

    API_URL = 'https://api.retellai.com'

    private_constant :API_URL

    def initialize
      @api_key = ENV.fetch('RETELL_API_KEY', nil)

      return unless @api_key.nil? || @api_key.strip.empty?

      raise InvalidCredentialsError, 'No RETELL_API_KEY found in environment variables'
    end

    def configure(api_key:)
      @api_key = api_key

      if @api_key.nil? || @api_key.strip.empty?
        raise InvalidCredentialsError, 'Empty API key provided to RetellAI client'
      end

      self
    end

    def connection
      if @api_key.nil? || @api_key.strip.empty?
        raise InvalidCredentialsError, 'Attempting to make API call without valid API key'
      end

      @connection ||= build_connection
    end

    private

    def build_connection
      ::Faraday.new(url: API_URL) do |faraday|
        configure_request_middlewares(faraday)
        configure_response_middlewares(faraday)
        configure_timeouts(faraday)
        faraday.adapter :net_http
      end
    end

    def configure_request_middlewares(faraday)
      faraday.request :json
      faraday.request :authorization, 'Bearer', @api_key
      faraday.request :retry,
                      max: RetellAI.configuration.retry_max_attempts,
                      interval: RetellAI.configuration.retry_interval,
                      interval_randomness: RetellAI.configuration.retry_interval_randomness,
                      backoff_factor: RetellAI.configuration.retry_backoff_factor,
                      exceptions: RetellAI.configuration.retry_exceptions
    end

    def configure_response_middlewares(faraday)
      faraday.use Middleware::ConvertToSnakeCase
      faraday.use Middleware::ErrorFormatter
    end

    def configure_timeouts(faraday)
      faraday.options.timeout = RetellAI.configuration.timeout
      faraday.options.open_timeout = RetellAI.configuration.open_timeout
    end
  end
end

# frozen_string_literal: true

require 'retell_ai/version'
require 'retell_ai/result'
require 'retell_ai/error'
require 'retell_ai/middleware'
require 'retell_ai/phone_call'
require 'retell_ai/phone_call/create'
require 'retell_ai/middleware/convert_to_snake_case'
require 'retell_ai/middleware/error_formatter'
require 'retell_ai/base_service'
require 'retell_ai/client'
require 'retell_ai/railtie' if defined?(Rails)

# RetellAI Ruby client for the Retell API - provides programmatic access to voice AI calls
module RetellAI
  Success = Result::Success
  Failure = Result::Failure

  class << self
    attr_accessor :configuration

    def client
      Client.instance
    end

    def configure(api_key: nil)
      self.configuration ||= Configuration.new
      self.configuration.api_key = api_key if api_key
      yield(configuration) if block_given?
    end

    def create_phone_call(from_number:, to_number:, agent_id: nil, metadata: nil, dynamic_variables: nil)
      PhoneCall::Create[
        from_number:,
        to_number:,
        agent_id:,
        metadata:,
        dynamic_variables:
      ]
    end
  end

  # Configuration class for the RetellAI client
  class Configuration
    attr_accessor :api_key, :retry_interval, :retry_interval_randomness, :retry_backoff_factor, :retry_exceptions,
                  :open_timeout

    # Retry configuration
    attr_accessor :retry_max_attempts

    # Timeout configuration
    attr_accessor :timeout

    def initialize
      # Default retry configuration
      @retry_max_attempts = 2
      @retry_interval = 0.05
      @retry_interval_randomness = 0.5
      @retry_backoff_factor = 2
      @retry_exceptions = [::Faraday::ConnectionFailed, ::Faraday::TimeoutError]

      # Default timeout configuration
      @timeout = 10
      @open_timeout = 5
    end
  end
end

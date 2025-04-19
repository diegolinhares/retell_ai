# frozen_string_literal: true

module RetellAI
  module Middleware
    # Middleware to format error responses according to RFC 9457 Problem Details
    class ErrorFormatter
      def initialize(app)
        @app = app
      end

      def call(env)
        @app.call(env)
      rescue RetellAI::Error => e
        problem_details = e.to_problem_details
        headers = {
          'Content-Type' => 'application/problem+json',
          'Content-Language' => 'en'
        }

        [
          problem_details[:status] || 500,
          headers,
          [problem_details.to_json]
        ]
      end
    end
  end
end

# frozen_string_literal: true

require 'active_support/hash_with_indifferent_access'
require 'active_support/core_ext/hash/keys'
require 'json'

module RetellAI
  module Middleware
    # Middleware to convert camelCase JSON response keys to snake_case format
    class ConvertToSnakeCase < ::Faraday::Middleware
      def on_complete(env)
        return unless env.response_headers['content-type']&.include?('application/json')
        return if env.body.nil? || env.body.empty?

        env.body => ::String

        ::JSON.parse(env.body)
              .deep_transform_keys(&:underscore)
              .then { ::ActiveSupport::HashWithIndifferentAccess.new(_1) }
      end
    end
  end
end

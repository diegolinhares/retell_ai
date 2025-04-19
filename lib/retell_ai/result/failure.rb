# frozen_string_literal: true

module RetellAI
  module Result
    # Represents a failed operation result
    class Failure
      attr_reader :error, :type

      # @param error [Object] The error that occurred
      # @param type [Symbol, nil] Optional type tag for the failure
      def initialize(error, type = nil)
        @error = error
        @type = type
      end

      # Factory method for creating a typed Failure
      # @param type [Symbol] The failure type
      # @param error [Object, nil] The error object
      # @return [Failure] A new Failure instance
      def self.[](type, error = nil)
        unless type.is_a?(Symbol)
          raise ArgumentError, "First parameter for Failure[] must be a Symbol, got: #{type.class}"
        end

        new(error, type)
      end

      # @return [Boolean] Always false for Failure
      def success?
        false
      end

      # @return [Boolean] Always true for Failure
      def failure?
        true
      end

      # No-op for Failure
      # @return [self] Returns self for method chaining
      def bind
        self
      end

      # No-op for Failure
      # @return [self] Returns self for method chaining
      def map
        self
      end

      # No-op for Failure
      # @return [self] Returns self for method chaining
      def on_success
        self
      end

      # Executes the block with the contained error
      # @yield [error] The contained error
      # @return [self] Returns self for method chaining
      def on_failure
        yield @error
        self
      end

      # Pattern matching support
      # @param _keys [Array] Keys to match (ignored)
      # @return [Hash] Components for pattern matching
      def deconstruct_keys(_keys)
        { error: @error, type: @type }
      end

      # Pattern matching support for positional destructuring
      # @return [Array] Components for positional pattern matching
      def deconstruct
        [@type, @error]
      end
    end
  end
end

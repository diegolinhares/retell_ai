# frozen_string_literal: true

module RetellAI
  module Result
    # Represents a successful operation result
    class Success
      attr_reader :value, :type

      # @param value [Object] The successful result value
      # @param type [Symbol, nil] Optional type tag for the success
      def initialize(value, type = nil)
        @value = value
        @type = type
      end

      # Factory method for creating a typed Success
      # @param type [Symbol] The success type
      # @param value [Object, nil] The success value
      # @return [Success] A new Success instance
      def self.[](type, value = nil)
        unless type.is_a?(Symbol)
          raise ArgumentError, "First parameter for Success[] must be a Symbol, got: #{type.class}"
        end

        new(value, type)
      end

      # @return [Boolean] Always true for Success
      def success?
        true
      end

      # @return [Boolean] Always false for Success
      def failure?
        false
      end

      # Transforms the contained value
      # @yield [value] The contained value
      # @return [Object] The result of the block
      def bind
        yield @value
      end

      # Maps the contained value to a new Success
      # @yield [value] The contained value
      # @return [Success] A new Success with the transformed value
      def map
        Success.new(yield @value, @type)
      end

      # Executes the block with the contained value
      # @yield [value] The contained value
      # @return [self] Returns self for method chaining
      def on_success
        yield @value
        self
      end

      # No-op for Success
      # @return [self] Returns self for method chaining
      def on_failure
        self
      end

      # Pattern matching support
      # @param _keys [Array] Keys to match (ignored)
      # @return [Hash] Components for pattern matching
      def deconstruct_keys(_keys)
        { value: @value, type: @type }
      end

      # Pattern matching support for positional destructuring
      # @return [Array] Components for positional pattern matching
      def deconstruct
        [@type, @value]
      end
    end
  end
end

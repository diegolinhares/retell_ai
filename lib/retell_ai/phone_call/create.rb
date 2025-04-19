# frozen_string_literal: true

module RetellAI
  module PhoneCall
    # Service for creating phone calls via the RetellAI API
    class Create < BaseService
      using PhoneCall::DataExtensions

      def call(from_number:, to_number:, agent_id: nil, metadata: nil, dynamic_variables: nil)
        validation_result = validate_phone_numbers(from_number, to_number)

        return validation_result if validation_result.failure?

        request_phone_call(
          from_number:,
          to_number:,
          agent_id:,
          metadata:,
          dynamic_variables:
        )
      end

      private

      def validate_phone_numbers(from_number, to_number)
        from_validation = validate_phone_number(from_number, 'from_number')
        return from_validation if from_validation.failure?

        to_validation = validate_phone_number(to_number, 'to_number')
        return to_validation if to_validation.failure?

        Success[:valid_phone_numbers]
      end

      def request_phone_call(from_number:, to_number:, agent_id: nil, metadata: nil, dynamic_variables: nil)
        response = client.connection.post('/v2/create-phone-call') do |req|
          req.body = {
            from_number:,
            to_number:,
            metadata:,
            override_agent_id: agent_id,
            retell_llm_dynamic_variables: dynamic_variables
          }.compact_blank.to_json
        end

        return Success[:api_response, response.body] if response.success?

        Failure[:api_error, ApiError.new(response.status, response.body)]
      rescue Faraday::Error => e
        Failure[:network_error, NetworkError.new("Error with Retell API: #{e.message}")]
      rescue StandardError => e
        Failure[:unexpected_error, UnexpectedError.new('Error occurred during phone call creation', e)]
      end

      def validate_phone_number(number, param_name)
        case number
        in String if number.start_with?('+') && number.length >= 8
          Success[:valid_phone_number]
        else
          Failure[:invalid_phone_number, InvalidPhoneNumberError.new(param_name, number)]
        end
      end
    end
  end
end

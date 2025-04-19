# frozen_string_literal: true

module RetellAI
  module PhoneCall
    # Extensions for the PhoneCall::Data class to enhance its functionality
    module DataExtensions
      refine RetellAI::PhoneCall::Data.singleton_class do
        def from_hash(hash)
          new(
            call_id: hash[:call_id],
            call_status: hash[:call_status],
            agent_id: hash[:agent_id],
            metadata: hash[:metadata],
            call_cost: hash[:call_cost]
          )
        end
      end
    end
  end
end

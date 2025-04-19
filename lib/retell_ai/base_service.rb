# frozen_string_literal: true

module RetellAI
  # Base service class that all RetellAI services inherit from
  class BaseService
    class << self
      def [](**params)
        new.call(**params)
      end
    end

    private

    def client
      @client ||= RetellAI.client
    end
  end
end

# frozen_string_literal: true

module RetellAI
  # Rails integration for RetellAI gem
  class Railtie < Rails::Railtie
    initializer 'retell_ai.configure' do
      RetellAI.configure(api_key: ENV.fetch('RETELL_API_KEY', nil)) if defined?(RetellAI)
    end
  end
end

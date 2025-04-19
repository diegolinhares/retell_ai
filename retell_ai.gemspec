# frozen_string_literal: true

require_relative 'lib/retell_ai/version'

Gem::Specification.new do |spec|
  spec.name = 'retell_ai'
  spec.version = RetellAI::VERSION
  spec.authors = ['Lyris Team']
  spec.email = ['team@example.com']

  spec.summary = 'Ruby wrapper for RetellAI API'
  spec.description = 'Ruby client for interacting with the RetellAI API'
  spec.required_ruby_version = '>= 3.3.0'

  spec.files = Dir['{lib}/**/*', 'README.md']
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '>= 6.0'
  spec.add_dependency 'faraday', '>= 1.0'
  spec.add_dependency 'faraday-retry', '>= 1.0'
  spec.add_dependency 'zeitwerk', '~> 2.6'
  spec.metadata['rubygems_mfa_required'] = 'true'
end

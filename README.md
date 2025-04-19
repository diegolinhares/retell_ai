# RetellAI Ruby Library

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A Ruby library for integrating with RetellAI's API for automated phone calls with AI agents.

## Table of Contents

- [Installation](#installation)
- [Requirements](#requirements)
- [Configuration](#configuration)
- [Usage](#usage)
  - [Making Phone Calls](#making-phone-calls)
  - [Result Handling](#result-handling)
  - [Pattern Matching](#pattern-matching-with-results)
- [Thread Safety](#thread-safety)
- [Accessing this Gem](#accessing-this-gem)
- [Support](#support)
- [Development](#development)
- [Contributing](#contributing)
- [License](#license)

## Installation

This library is part of the main application and doesn't need separate installation. It's already available in your Rails application.

## Requirements

- Ruby 2.7 or higher
- Rails 6.0 or higher (for Rails integration features)

## Configuration

The RetellAI client uses a Singleton pattern, ensuring only one instance is created and reused across your application.

```ruby
# Configure with a custom API key
RetellAI.configure(api_key: 'your_custom_api_key')

# By default, it uses the RETELL_API_KEY environment variable
```

### Advanced Configuration Options

```ruby
RetellAI.configure(
  # Credentials
  api_key: 'your_api_key',
  
  # Timeouts (in seconds)
  connect_timeout: 5,     # Timeout for establishing a connection
  read_timeout: 30,       # Timeout for reading a response
  
  # Retry and backoff
  max_retries: 3,         # Maximum number of retries for failed requests
  retry_interval: 2       # Initial interval between retries (in seconds)
)
```

### Block Configuration

You can also configure using a block:

```ruby
RetellAI.configure do |config|
  config.api_key = 'your_api_key'
  config.read_timeout = 60            # For calls that might take longer
  config.max_retries = 5              # Increase retry attempts
end
```

## Usage

### Making Phone Calls

```ruby
# Create a phone call
result = RetellAI.create_phone_call(
  from_number: '+15551234567',  # E.164 format
  to_number: '+15557654321',    # E.164 format
  agent_id: 'your_agent_id',    # Optional
  metadata: {                   # Optional
    user_id: 123,
    session: 'abc123'
  },
  dynamic_variables: {          # Optional
    customer_name: 'Jane Smith',
    appointment_time: '3:00 PM'
  }
)

# Handle the result
if result.success?
  puts "Call initiated successfully!"
  puts "Call ID: #{result.value['call_id']}"
  puts "Status: #{result.value['call_status']}"
else
  puts "Call failed: #{result.error.message}"
end
```

### Result Handling

The library uses a Result monad pattern for handling success and failure cases.

#### Success Results

```ruby
# Check if a result was successful
if result.success?
  # Do something with success
end

# Extract value from success result
result.on_success do |data|
  puts "Call ID: #{data['call_id']}"
end

# Chain operations
result
  .on_success { |data| save_call_id(data['call_id']) }
  .on_failure { |error| log_error(error.message) }
```

#### Failure Results

```ruby
# Check if a result was a failure
if result.failure?
  # Handle the error
end

# Extract error from failure result
result.on_failure do |error|
  puts "Error: #{error.message}"
  puts "Type: #{error.type}"
end
```

### Pattern Matching with Results

Ruby's pattern matching (introduced in Ruby 2.7) works elegantly with our Result classes. You can use both positional pattern matching and pattern matching with keys:

```ruby
# Positional pattern matching (recommended)
case RetellAI.create_phone_call(from_number: '+15551234567', to_number: '+15557654321')
in RetellAI::Success[_, data]
  puts "Success with data: #{data}"
in RetellAI::Failure[_, error]
  puts "Failure with error: #{error.message}"
end

# Pattern matching with type checking
case RetellAI.create_phone_call(from_number: '+15551234567', to_number: '+15557654321')
in RetellAI::Success[:api_response, data]
  puts "API response received: #{data['call_id']}"
in RetellAI::Failure[:invalid_phone_number, error]
  puts "Invalid phone number: #{error.message}"
in RetellAI::Failure[:api_error, error]
  puts "API error: #{error.message}"
end

# Alternative: Pattern matching using keys
case RetellAI.create_phone_call(from_number: '+15551234567', to_number: '+15557654321')
in RetellAI::Success[value: data]
  puts "Success with data: #{data}"
in RetellAI::Failure[error: error, type: :invalid_phone_number]
  puts "Invalid phone number: #{error.message}"
in RetellAI::Failure[error: error, type: :api_error]
  puts "API error: #{error.message}"
end
```

Note that for positional pattern matching:
- The first parameter is the `type` (which can be ignored with `_`)
- The second parameter is the `value` for `Success` or `error` for `Failure`

## Thread Safety

The RetellAI client is implemented as a thread-safe singleton using Ruby's built-in Singleton module, making it safe to use in multi-threaded environments.

## Accessing this Gem

1. Add to your Gemfile:
   ```ruby
    gem 'retell_ai', path: 'gems/retell_ai'
   ```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
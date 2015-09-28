# Murmur

A ruby client for controlling and querying the Mumble server (Murmur)

## Installation

Install it from RubyGems:

```
gem install murmur
```

Or add it to a Gemfile:

```
gem 'murmur'
```

## Usage

Configuration:

```
require 'murmur'

Murmur.client(
    :host => '127.0.0.1', # The host of the Murmur server.
    :port => '', # The port of the Murmur server.
    :glacier_user, # The user (if using Glacier2)
    :glacier_pass, # The password (if using Glacier2)
    :ice_secret) # The Ice secret.
```

Examples:

```
# Get a server
Murmur.get_server(1)

# Create a new server
Murmur.new_server(:name => "Hi!")
```


# Murmur

A ruby client for controlling and querying the Mumble server (Murmur).

Also capable of connecting to Murmur servers through [Glacier2](http://wiki.mumble.info/wiki/Ice#Using_Glacier2).

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
    :host => '127.0.0.1', # Host of the Murmur server.
    :port => '6502', # Port of the Murmur server.
    :glacier_user => '', # Username to connect with (if using Glacier2)
    :glacier_pass => '', # Password to connect with (if using Glacier2)
    :ice_secret => '' # Ice secret of the Murmur server.
)
```

Examples:

```
# Get a server
Murmur.server(1)

# Create a new server
Murmur.new_server(:registername => "Server name")

# Get the channels of a server
server = Murmur.server(1)
server.channels

# Get a specific channel of a server
server = Murmur.server(1)
server.channel(1)

# Change the name of a channel
server = Murmur.server(1)
channel = server.channel(1)
channel.name = "New name!"

# Get the clients of a server
server = Murmur.server(1)
users = server.users

# Change a user's name
server = Murmur.server(1)
user = server.users.first
user.name = "New name!"
```

The #raw function on Murmur::API objects will return the raw Murmur object, allowing calling of unimplemented functions, or simply call the unimplemented function on the object and it'll be passed to the raw Murmur object.


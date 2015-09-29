module Murmur
    module API
        class Channel

            def initialize(host, meta, server, channel)
                @host = host
                @meta = meta
                @server = server
                @channel = channel
            end

            def id
                @channel.id
            end

            def name
                @channel.name
            end

            def name=(name)
                @channel.name = name
                update
            end

            def server
                @server
            end

            def parent
                @server.channel(@channel.parent)
            end

            def parent=(id)
                @channel.parent = id
                update
            end

            def links
                @channel.links
            end

            def temporary?
                @channel.temporary
            end
            alias :temporary :temporary?

            def temporary=(temp)
                @channel.temporary = temp
                update
            end

            def description
                @channel.description
            end

            def description=(description)
                @channel.description = description
                update
            end

            def position
                @channel.position
            end

            def position=(id)
                @channel.position = id
                update
            end

            private

            def update
                channel_state = @server.getChannelState(id)

                ["name", "description", "temporary", "position"].each do |func|
                    channel_state.send("#{func}=", send(func))
                end

                # Set 'parent' normally.
                channel_state.parent = parent.id

                @server.setChannelState(channel_state)
            end

        end
    end
end

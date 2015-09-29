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
                @channel[:id]
            end

            def name
                @channel[:name]
            end

            def name=(name)
                @channel[:name] = name
            end

            def server
                @server
            end

            def parent
                @server.channel(@channel[:parent])
            end

            def parent=(id)
                @channel[:parent] = id
            end

            def links
                @channel[:links]
            end

            def temporary?
                @channel[:temporary]
            end

            def description
                @channel[:description]
            end

            def description=(description)
                @channel[:description] = description
            end

            def position
                @channel[:position]
            end

            def position=(id)
                @channel[:position] = id
            end

        end
    end
end

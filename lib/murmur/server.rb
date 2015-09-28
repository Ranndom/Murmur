module Murmur
    class Server

        def initialize(host, meta, options)
            @host = host
            @meta = meta

            if !options[:id] and !options[:interface]
                options.delete :id
                options.delete :interface

                server = @host.new_server_interface

                @interface = host.add_proxy_router(server)

                options.each do |key, value|
                   setConf(key, value)
                end
            end

            @interface = @interface || options[:interface] || begin
                server = @meta.getServer(options[:id])
                raise ::Murmur::Ice::InvalidServerException if server.nil?
                host.add_proxy_router(server)
            end
        end

        def id
            @interface.id
        end

        def running?
            @interface.isRunning
        end

        def config
            @config = @meta.getDefaultConfig.merge(@interface.getAllConf)
        end

        def destroy!
            @interface.stop if running?
            @host.uncache_server id
            @interface.delete
        end
        alias :delete :destroy!

        def restart!
            @interface.stop if running?
            @interface.start
        end

        def [](key)
            config[key]
        end

        def []=(key, val)
            @interface.setConf(key, val.to_s)
            @config = nil
        end

        def setConf(key, val)
            self[key] = val
        end

        def method_missing(method, *args)
            method = method.to_s
            method.gsub!(/_([a-z])/) { $1.upcase }
            ret = @interface.send method, *args
        end

    end
end

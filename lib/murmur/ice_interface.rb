require 'Glacier2'
require 'murmur/server'
require File.join(File.expand_path(File.dirname(__FILE__)), "../../vendor/ice/Murmur.rb")

module Murmur

    class Meta
        
        def initialize(options = {})
            # Default options
            options = {:host => '127.0.0.1', :port => 6502}.merge(options)

            if options[:ice_secret]
                props = ::Ice::createProperties
                props.setProperty "Ice.ImplicitContext", "Shared"
                props.setProperty "Ice.Default.EncodingVersion", "1.0"

                ice_init_data = ::Ice::InitializationData.new
                ice_init_data.properties = props

                ice_context = ::Ice::initialize ice_init_data
                ice_context.getImplicitContext.put("secret", options[:ice_secret])
            else
                props = ::Ice::createProperties
                props.setProperty "Ice.Default.EncodingVersion", "1.0"

                ice_init_data = ::Ice::InitializationData.new
                ice_init_data.properties = props

                ice_context = ::Ice::initialize ice_init_data
            end

            if options[:glacier_host]
                prx = ice_context.stringToProxy("Glacier2/router:tcp -h #{options[:glacier_host]} -p #{options[:glacier_port]}")
                @router = ::Glacier2::RouterPrx::uncheckedCast(prx).ice_router(nil)
                @session = @router.createSession(options[:glacier_user], options[:glacier_pass])
            end

            conn = "tcp -h #{options[:host]} -p #{options[:port]}"
            proxy = ice_context.stringToProxy("Meta:#{conn}")
            puts proxy.inspect
            @meta = add_proxy_router(Murmur::MetaPrx::checkedCast(proxy))
            raise "Invalid proxy" unless @meta

            @servers = {}
        end

        def destroy
            begin
                @router.destroySession @session unless @router.nil?
            rescue ::Ice::ConnectionLostException
            end

            nil
        end

        def add_proxy_router(prx)
            @router ? prx.ice_router(@router) : prx
        end

        def get_server(id)
            @servers[id] ||= Server.new(self, @meta, {:id => id})
        end

        def uncache_server(id)
            @servers[id] = nil
        end

        def list_servers
            @meta.send(:getAllServers).collect do |server|
                server = add_proxy_router server
                @servers[server.id] ||= Server.new(self, @meta, {:interface => server})
            end
        end

        def new_server_interface
            server = @meta.newServer
        end

        def new_server(options = {})
            Server.new(self, @meta, options)
        end

        def validate
            @meta.getVersion
            true
        end

    end

end

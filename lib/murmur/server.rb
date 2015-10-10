require 'murmur/channel'
require 'murmur/user'

module Murmur
    module API
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

                @channels = {}
                @users = {}
                @registered_users = {}
            end

            def id
                @interface.id
            end

            def running?
                @interface.isRunning
            end

            def channel(id)
                channels

                @channels[id]
            end

            def channels
                @channels = {}
                @interface.getChannels.each do |_, channel|
                    @channels[channel.id] = Channel.new(@host, @meta, self, channel)
                end
                @channels
            end

            def users
                @users = {}
                @interface.getUsers.each do |_, user|
                    @users[user.session] = User.new(@host, @meta, self, user)
                end
                @users
            end

            def registered_users
                @registered_users = {}
                @interface.getRegisteredUsers.each do |_, user|
                    @registered_users[user.session] = User.new(@host, @meta, self, user)
                end
                @registered_users
            end

            def user(session)
                users

                @users[:session]
            end

            def config
                @config = @meta.getDefaultConf.merge(@interface.getAllConf)
            end

            def destroy!
                @interface.stop if running?
                @host.uncache_server id
                @interface.delete
            end
            alias :delete :destroy!

            def start!
                @interface.start unless running?
            end

            def stop!
                @interface.stop if running?
            end

            def restart!
                @interface.stop if running?
                @interface.start
            end

            def [](key)
                key = key.to_s
                config[key]
            end

            def []=(key, val)
                key - key.to_s
                @interface.setConf(key, val.to_s)
                @config = nil
            end

            def setConf(key, val)
                key = key.to_s
                self[key] = val
            end
            
            def raw
                @interface
            end

            def method_missing(method, *args)
                method = method.to_s
                method.gsub!(/_([a-z])/) { $1.upcase }
                ret = @interface.send method, *args
            end

        end
    end
end

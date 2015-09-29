module Murmur
    module API
        class User
            
            def initialize(host, meta, server, user)
                @host = host
                @meta = meta
                @server = server
                @user = user
            end

            def session
                @user.session
            end
            alias :id :session

            def userid
                @user.userid
            end

            def muted?
                @user.mute
            end

            def deafened?
                @user.deaf
            end

            def suppressed?
                @user.suppress
            end

            def priorityspeaker?
                @user.prioritySpeaker
            end

            def clientmuted?
                @user.selfMute
            end

            def clientdeafened?
                @user.selfDeaf
            end

            def recording?
                @user.recording
            end

            def channel
                @server.channel @user.channel
            end

            def server
                @server
            end

            def name
                @user.name
            end

            def seconds_connected
                @user.onlinesecs 
            end
            
            def seconds_idle
                @user.idlesecs
            end

            def bytes_per_sec
                @user.bytespersec
            end

            def version
                @user.version
            end

            def release
                @user.release
            end

            def os
                @user.os
            end

            def os_version
                @user.osversion
            end

            def identity
                @user.identity
            end

            def context
                @user.context
            end

            def comment
                @user.comment
            end

            def tcponly?
                @user.tcponly
            end

            def ping
                {:udp => @user.udpPing, :tcp => @user.tcpPing}
            end

            def udpPing
                ping[:udp]
            end

            def tcpPing
                ping[:tcp]
            end

        end
    end
end

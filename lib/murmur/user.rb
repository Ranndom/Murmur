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

            def muted=(muted)
                @user.mute = muted
                update
            end

            def deafened?
                @user.deaf
            end

            def deafened=(deafened)
                @user.deaf = deafened
                update
            end

            def suppressed?
                @user.suppress
            end

            def suppressed=(suppressed)
                @user.suppress = suppressed
                update
            end

            def priorityspeaker?
                @user.prioritySpeaker
            end

            def priorityspeaker=(priorityspeaker)
                @user.prioritySpeaker = priorityspeaker
                update
            end

            def clientmuted?
                @user.selfMute
            end

            def clientmuted=(clientmuted)
                @user.selfMute = clientmuted
                update
            end

            def clientdeafened?
                @user.selfDeaf
            end

            def clientdeafened=(clientdeafened)
                @user.selfDeaf = clientdeafened
                update
            end

            def recording?
                @user.recording
            end

            def recording=(recording)
                @user.recording
                update
            end

            def channel
                @server.channel @user.channel
            end

            def channel=(channel)
                @user.channel = channel
                update
            end

            def server
                @server
            end

            def name
                @user.name
            end

            def name=(name)
                @user.name = name
                update
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

            def comment=(comment)
                @user.comment = comment
                update
            end

            def tcponly?
                @user.tcponly
            end

            def tcponly=(tcponly)
                @user.tcponly = tcponly
                update
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

            def update
                user_state = @server.getState(id)

                {
                    :muted? => :mute,
                    :deafened? => :deaf,
                    :suppressed? => :suppress,
                    :priorityspeaker? => :prioritySpeaker,
                    :clientmuted? => :selfMute,
                    :clientdeafened? => :selfDeaf,
                    :recording? => :recording,
                    :tcponly? => :tcponly,
                    :name => :name
                }.each do |local, state|
                    user_state.send("#{state}=", send(local))
                end

                # Set 'channel' normally.
                user_state.channel = channel.id

                @server.setState(user_state)
            end 

            # Aliases for update function to work properly.
            # Maybe one day I'll fix this.
            # alias :mute :muted?
            # alias :deaf :deafened?
            # alias :suppress :suppressed?
            # alias :prioritySpeaker :priorityspeaker?
            # alias :selfMute :clientmuted?
            # alias :selfDeaf :clientdeafened?
            # alias :recording :recording?
            # alias :tcponly :tcponly?

        end
    end
end

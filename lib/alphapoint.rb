require "alphapoint/version"
require 'faye/websocket'
require 'eventmachine'
require 'alphapoint/get_products'

module Alphapoint

	REQUEST = 0
	SUBSCRIBE = 2
	UNSUBSCRIBE = 4

	class Error < StandardError; end

 	class WebSocket

		def initialize(address)
			@address = address
			@nextIValue = 2
			@actions = []
			@unsub_actions = []
		end

		def register_action(action)
			@actions << action

			EM.stop_event_loop if EM.reactor_running?
			
			return @actions
		end

		# Se a ação for de subscribe precisa mandar um unsubscribe pro servidor
		def drop_actions
			mapped_actions = @actions

			if block_given? 
				mapped_actions = @actions.select { |action| yield(action) }
			end

			@unsub_actions += mapped_actions.select { |action| action.type == SUBSCRIBE }
			
			@actions -= mapped_actions
		end

		def drop_action(id)
			mapped_action = @actions.select { |action| action.iValue != id}
	
			@unsub_actions += mapped_action if mapped_action.type == SUBSCRIBE
			
			@actions -= mapped_action
		end

		def execute			
			EM.run{
				@ws = Faye::WebSocket::Client.new(@address)

				@ws.on :open do |event|
					@actions.each do |action|
						p [:open, action.class.name]

						action.iValue = @nextIValue

						frame = action.mount_frame
						@ws.send(frame)

						@nextIValue += 2
					end
				end

				@ws.on :message do |event|
					p [:message]
					data = JSON.parse(event.data)

					# Check actions that are unsubscribing
					# And notify the server (ISSO FUNCIONA?)
					@unsub_actions.each do |action|
						action.type = UNSUBSCRIBE
						action.setPayloadNil

						frame = action.mount_frame

						@ws.send(frame)
					end


					received_action = @actions.select { |action| action.iValue == data['i']}

					if !received_action.nil?
						received_action.first.handle_response(data)
						p [:message, received_action.class.name]

						if received_action.count > 1
							p "Warning: More than one action with same id were retrieved, only one was treated"
						end
					else
						p "Error: Received message has no correspondent id"
					end
				end

				@ws.on :close do |event|
					p [:close]
				end
			}
		end
	end

end



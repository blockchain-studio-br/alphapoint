module Alphapoint
	class WebSocket
		def initialize
			file_path = File.join(File.dirname(__FILE__),"/alphapoint.yml")
			Alphapoint.configure_with file_path

			@address = Alphapoint.config[:address]
			@nextIValue = 2
			@actions = []
			@unsub_actions = []
		end

		def register_action(action)
			@actions << action

			EM.stop_event_loop if EM.reactor_running?
			
			return @actions
		end

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

					unsubscribe_dropped_actions

					delegate_message(data)
				end

				@ws.on :close do |event|
					p [:close]
				end
			}
		end

		private

			# Check actions that are unsubscribing
			# And notify the server
			def unsubscribe_dropped_actions
				@unsub_actions.each do |action|
					action.type = UNSUBSCRIBE
					action.setPayloadNil

					frame = action.mount_frame

					@ws.send(frame)
				end
			end

			# Finds the action responsible for the received message
			def delegate_message(data)
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
	end # End Class
end # End Module
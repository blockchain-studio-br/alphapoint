require 'json'

module Alphapoint

	class WebSocket
		
		attr_accessor :address

		def initialize(address = nil)
			if Alphapoint.configuration.nil? || 
				Alphapoint.configuration.address.nil? ||
					Alphapoint.configuration.address.empty? 
				raise AlphapointError, "Pass or configure an address to conect on WebSocket"				
			end

			@ws = nil
			@address = address || Alphapoint.configuration.address
			@nextIValue = 2
			@actions = []
			@unsub_actions = []
		end

		def ws_instance 
			@ws = Faye::WebSocket::Client.new(@address) unless @ws
			@ws
		end

		def register_action(action)
			unless action.class < Alphapoint::Call::Base
				raise Alphapoint::AlphapointError, "Actions need to inherit Alphapoint::Call::Base"
			end

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

		def execute_requests
			number_of_actions = @actions.length
			responses_receive = 0
			alpha_self = self
			EM.run do
				ws = alpha_self.ws_instance

				ws.on :open do |event|
					p [:open, "Websocket connected to #{@address}"]
				end

				ws.on :message do |event|
					delegate_message(JSON.parse(event.data))
					responses_receive += 1
					EM.stop if responses_receive == number_of_actions
				end

				ws.on :close do |event|
					p [:close]
				end

				alpha_self.send_requests	
			end

			true
		end

		def send_requests

			@actions
				.select { |elem| elem.type == Alphapoint::Call::REQUEST }
				.each do |action|
					frame = JSON.generate(action.mount_frame(@nextIValue))
					self.ws_instance.send(frame)
					@nextIValue += 2
				end
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
					received_action.first.value = data['o']
					received_action.first.handle_response(data['o'])
					
					if received_action.count > 1
						p "Warning: More than one action with same id were retrieved, only one was treated"
					end
				else
					p "Error: Received message has no correspondent id"
				end
			end
	end # End Class

end # End Module
require "alphapoint/version"
require 'faye/websocket'
require 'eventmachine'
require 'alphapoint/get_products'

module Alphapoint

	REQUEST = 0
	SUBSCRIBE = 2

	class Error < StandardError; end

 	class WebSocket

		def initialize(address)
			@address = address
			@nextIValue = 2
			@actions = []
		end

		def register_action(action, type)
			action.type = type
			@actions << action
			EventMachine::stop_event_loop # checar esse comando
		end

		def drop_actions(condition)
			map_actions = @actions.select { |action| 
				action.type != condition.second and action.class.name != condition.first
			}
			@actions = map_actions
			EventMachine::stop_event_loop # checar esse comando
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

					received_action = @actions.select { |action| action.iValue == data['i']}

					if !received_action.nil?
						received_action.first.handle_response(data)
						p [:message, received_action.class.name]

						if received_action.count > 1
							p "Warning: More than one action with same id were retrieved, only one was treated"
						end
					else
						raise "Error: Received message has no correspondent id"
					end
				end

				@ws.on :close do |event|
					p [:close]
				end
			}
		end
	end

end



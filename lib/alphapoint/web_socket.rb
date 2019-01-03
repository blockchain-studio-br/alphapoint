require 'json'

module Alphapoint

	class WebSocket
		
		attr_accessor :address

		def connect(address = nil, &block)
			if Alphapoint.configuration.nil? || 
				Alphapoint.configuration.address.nil? ||
					Alphapoint.configuration.address.empty? 
				raise AlphapointError, "Pass or configure an address to conect on WebSocket"				
			end

			@ws = nil
			@address = address || Alphapoint.configuration.address
			@nextIValue = 2
			@avaliable_functions = [
				"GetInstrument",
				"GetInstruments",
				"GetProduct",
				"GetProducts",
				"SendOrder",
				"SubscribeLevel1",
				"WebAuthenticateUser"
			]
			@response = {}
			
			@unsub_actions = []

			alpha_self = self

			@thread = Thread.new do 
				EM.run do
					@ws = Faye::WebSocket::Client.new(@address)

					@ws.on :open do |event|
						p [:open, "Websocket connected to #{@address}"]
						block.call(self)
					end

					@ws.on :message do |event|
						alpha_self.delegate_message(JSON.parse(event.data).with_indifferent_access)
					end

					@ws.on :error do |event|
					  	p [:error, event.inspect]
					end

					@ws.on :close do |event|
						p [:close, event.code, event.reason]
					end
				end
			end

			p @thread.status

			trap(:INT) { EM.stop }
			trap(:TERM){ EM.stop }
			
			while not EM.reactor_running?; end
		    while not EM.defers_finished?; end
		    
		    self
		end

		def build_request(function_name, payload,type = 0, &block)
			frame = {
			  'm': type,
			  'i': @nextIValue,
			  'n': function_name,
			  'o': JSON.generate(payload)
			}

			@response[@nextIValue] = block
			@nextIValue += 2

			@ws.send(JSON.generate(frame))
		end

		# Finds the action responsible for the received message
		def delegate_message(data)
			received_action = @response[data['i']]

			if !received_action.nil? && received_action.is_a?(Proc)
				received_action.call(JSON.parse(data['o']))
				@response[data['i']] = nil
			else
				raise "Error: Received message has no correspondent id"
			end
		end

		def get_quotes(payload = { OMSId: 1 }, &block) 
			quotes = Alphapoint::GetQuotes.new(self)

			quotes.execute(payload) do |res|
				block.call(res)
			end
		end

		def method_missing(m, *args, &block)
			function_name = m.to_s.camelcase
			respond_action = @avaliable_functions.select{ |func| func ==  function_name }
			if respond_action.size > 0
				puts "Delegating to action: #{m}"

				payload = args[0] || {}
				type = args[1].to_i || 0

				build_request(function_name, payload, type) do |response|
					block.call(response)
				end
			else
				raise "Method #{m} not implemented yet"
			end
		end
			
	end # End Class

end # End Module
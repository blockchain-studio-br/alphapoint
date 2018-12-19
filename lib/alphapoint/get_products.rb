module AlphaPoint
	class GetProducts < AlphaPoint

  		def initialize(address)
  			super(address)
  		end

		def execute
			EM.run {
				@ws.on :open do |event|
					p [:open]
	    			payload = {
	    				"OMSId": 1,
						"ProductId": 1,
	    			}

	    			frame = {
	    				'm': 0,
	    				'i': 2,
	    				'n': 'GetProduct',
	    				'o': payload.to_json
	    			}

	    			@ws.send(frame.to_json)
				end

				@ws.on :message do |event|
	    			p [:message, event.data]
			  	end

				@ws.on :close do |event|
				  p [:close, event.code, event.reason]
				  @ws = nil
				end
			}
		end

	end
end
require 'json'

module Alphapoint
	class GetProducts
		@@call_name = 'GetProducts'

		attr_accessor :iValue
		attr_accessor :type

		def initialize(payload)
			@payload = payload
		end

		def setPayloadNil
			@payload = nil
		end

		# Executes the actual call for GetProducts
		def mount_frame
			frame = {
				'm': @type,
				'i': @iValue,
				'n': @@call_name,
				'o': JSON.generate(@payload)
			}

			return JSON.generate(frame)
		end

		def handle_response(data)
			# p data # This is for debugging only

			if data['m'] == 1 # reply
				if data['n'] == @@call_name
					p data
				end
			end
		end
	end
end
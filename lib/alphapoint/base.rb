require 'json'

module Alphapoint
	class Base
		@@call_name = 'BaseFunction'

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
		end
	end
end
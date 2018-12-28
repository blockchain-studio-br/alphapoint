require 'json'

module Alphapoint
	class Base
		@@call_name = 'BaseFunction'

		attr_accessor :iValue
		attr_accessor :type

		def initialize(payload = {}, type = 2)
			@payload = payload
			@type = type
			@response = nil
		end

		def setPayloadNil
			@payload = nil
		end

		def mount_frame
			frame = {
				'm': @type,
				'i': @iValue,
				'n': @@call_name,
				'o': JSON.generate(@payload)
			}

			return frame
		end

		def handle_response(data)			
		end
	end
end
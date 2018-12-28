require 'json'

module Alphapoint

	module Call

		class Base
			
			attr_accessor :iValue, :type, :value

			def initialize(payload = {}, type = 2)
				@call_name = 'BaseFunction'
				@payload = payload
				@type = type
				@response = nil
				@iValue = nil
				@value = nil
			end

			def setPayloadNil
				@payload = nil
			end

			def mount_frame(iValue)
				@iValue = iValue
				frame = {
					'm': @type,
					'i': @iValue,
					'n': @call_name,
					'o': JSON.generate(@payload)
				}

				return frame
			end

			def handle_response(data)			
			end
		end

	end

end
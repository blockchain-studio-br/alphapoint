require 'alphapoint/call/base'

module Alphapoint

	module Call

		class GetProduct < Base

			def initialize(payload = {}, type = 2)
				super(payload, type)
				@call_name = 'GetProduct'
			end
			

			def handle_response(data)
				p(data)
			end
		end

	end

end




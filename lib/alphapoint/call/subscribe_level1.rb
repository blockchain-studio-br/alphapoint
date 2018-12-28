require 'alphapoint/call/base'

module Alphapoint

	module Call

		class SubscribeLevel1 < Base

			def initialize(payload = {}, type = 2)
				super(payload, type)
				@call_name = 'SubscribeLevel1'
			end
			

			def handle_response(data)
				p(data)
			end
		end

	end

end

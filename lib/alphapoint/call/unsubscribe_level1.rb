require 'alphapoint/call/base'

module Alphapoint

	module Call

		class UnsubscribeLevel1 < Base

			def initialize(payload = {}, type = 2)
				super(payload, type)
				@call_name = 'UnsubscribeLevel1'
			end
			

			def handle_response(data)
				p(data)
			end
		end

	end

end


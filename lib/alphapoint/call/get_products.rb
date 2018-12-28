require 'alphapoint/call/base'

module Alphapoint

	module Call

		class GetProducts < Base
			@@call_name = 'GetProducts'

			def handle_response(data)
				p(data)
			end
		end

	end

end
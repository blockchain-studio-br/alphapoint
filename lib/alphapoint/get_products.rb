require 'alphapoint/base'

module Alphapoint
	class GetProducts < Base
		@@call_name = 'GetProducts'

		def handle_response(data)
			if data['m'] == Alphapoint.response_of(@type)
				if data['n'] == @@call_name
					p(data)
					@response = data['o']
				end
			end
		end
	end
end
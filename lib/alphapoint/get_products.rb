require 'json'

module Alphapoint
	class GetProducts < Base
		@@call_name = 'GetProducts'

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
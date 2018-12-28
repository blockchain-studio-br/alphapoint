require 'alphapoint/base'

module Alphapoint
	class GetProducts < Base
		@@call_name = 'GetProducts'

		def handle_response(data)
			p(data)
		end
	end
end
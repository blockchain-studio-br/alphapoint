require "alphapoint/version"
require 'faye/websocket'
require 'eventmachine'

module Alphapoint
  class Error < StandardError; end
  
  class Alphapoint
		def initialize(address)
			@ws = Faye::WebSocket::Client.new(address)

			# EM.run {
			# 	@ws.on :open do |event|
			# 		p [:open]
	  		#   	#@ws.send('Hello, world!')
			# 	end
			# }

			puts("Created socket object!")

			# @actions = { 
	  # 			GetProducts: "Alphapoint::GetProducts"
   #  		}
		end
	end

end



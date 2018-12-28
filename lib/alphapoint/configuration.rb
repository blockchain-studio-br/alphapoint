module Alphapoint

	class Configuration

		attr_accessor 	:address,  :user, :password

	    def initialize
	      	@address = nil
			@user = nil
			@password = nil
	    end

	end
end
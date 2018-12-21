class getproducts

	def initialize(ws, payload)
		@ws = ws
		@payload = payload
	end

	def send
		@index = index
		frame = {
			'm': 0,
			'i': @index,
			'n': 'GetProducts',
			'o': @payload.to_json
		}

		@ws.send(frame.to_json)
	end

	def receive(data)
	end
end


class alphapointsuper
	def initialize(classes)
		@actions = classes
	end

	def execute()
		EM.run{
			@ws.on :open do |event|
				p [:open, "aaaa"]
				
				@actions.each do |action|
					index = generateindex()
    				action.send(index)
    			end
			end

			@ws.on :message do |event|
    			p [:message, event.data]

    			map_action = @actions.select do |action|
    				return JSON.parse(event.data)['i'] == action.index
    			end

    			if !map_action.first.nil?
    				map_action.first.receive(JSON.parse(event.data)['o'])
    			end
		  	end

			@ws.on :close do |event|
			  p [:close, event.code, event.reason]
			  # @ws = nil
			end
		}
	end


end

get_pro = GetProducts.new(ws, payload)
classes = {get_pro}

alp = alphapointsuper.new(classes)
alp.execute 



alp.send("getproducts", payload) do 


	  		# Implementing the singleton pattern

  # 		# Making the new class private
  # 		private_class_method :new

  # 		@@instance = nil

  # 		# Returns the instance of GetProducts if it exists
		# def self.instance
		# 	if @@instance == nil
		# 		raise "Error: Missing address parameter (use AlphapointSuper.instance(address) instead)"
		# 	end

		# 	return @@instance
		# end

  # 		# Returns the instance of GetProducts if it exists
  # 		# If it doesnt exists already, it is created passing the address
		# def self.instance(address)
		# 	if @@instance == nil
		# 		@@instance = AlphapointSuper.new(address)
		# 		return @@instance
		# 	end

		# 	return @@instance
		# end


		# Implementing the class methods
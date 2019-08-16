module Alphapoint

	class GetQuotes

		def initialize(ws)
			@ws = ws

			@data = []
			@instruments_number = -1
			@count = 0
		end

		def execute(payload, &block)
			@ws.get_instruments(payload) do |res|
				res.each do |inst|
					payloadSub = payload.merge({ InstrumentId: inst['InstrumentId'] })
					@ws.subscribe_level1(payloadSub) do |ticker|
						@data << ticker.merge(inst)
						@count += 1
						block.call(@data) if res.size == @count
					end
				end
			end
		end

	end

end

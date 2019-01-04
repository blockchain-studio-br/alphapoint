require "spec_helper"

RSpec.describe Alphapoint::WebSocket do

  context "Initializng WebSocket"  do

  	context "without setting configurations" do 

	  	it "expect a to have a address on configurations to conect" do 
	  		expect {
	  			Alphapoint::WebSocket.new
	  		}.to raise_error(Alphapoint::AlphapointError, "Pass or configure an address to conect on WebSocket")
	  	end

	end

  	context "with setting configurations" do 

  		before(:all) do
		    Alphapoint.configure do |config| config.address = "wss://api_apexqa.alphapoint.com/WSGateway/" end
		end

	  	it "expect a to create object with configurations options" do 
	  		expect {
	  			Alphapoint::WebSocket.new
	  		} .not_to raise_error
	  	end

		it "expect a to create object with a address passed in constructor" do 
	  		ws = Alphapoint::WebSocket.new("wss://example.api_apexqa.alphapoint.com/WSGateway/")
	  		expect(ws.address).to eq("wss://example.api_apexqa.alphapoint.com/WSGateway/")
	  		
	  		
	  	end

	end

  end

  context "Resquest to atomic functions " do 

  	before(:all) do
	    Alphapoint.configure do |config| config.address = "wss://api_apexqa.alphapoint.com/WSGateway/" end
		end

	let(:web_socket) {Alphapoint::WebSocket.new}
	

	let(:mocked_get_products_valid_response) {[
			{"OMSId": 1, "ProductId": 1, "Product": "BTC", "ProductFullName": "Bitcoin", "ProductType": "CryptoCurrency", "DecimalPlaces": 8, "TickSize": 1.0, "NoFees": false}
		]
	}

	let(:mocked_get_product_valid_response) {
			{"OMSId": 1, "ProductId": 1, "Product": "BTC", "ProductFullName": "Bitcoin", "ProductType": "CryptoCurrency", "DecimalPlaces": 8, "TickSize": 1.0, "NoFees": false}
	}

	let(:mocked_get_instruments_valid_response) do
		[
			{	
				"OMSId": 1, "InstrumentId": 1, "Symbol": "BTCUSD", "Product1": 1, "Product1Symbol": "BTC",
				"Product2": 2, "Product2Symbol": "USD", "InstrumentType": "Standard", "VenueInstrumentId": 1,
				"VenueId": 0, "SortIndex": 0, "SessionStatus": "Running", "PreviousSessionStatus": "Stopped",
				"SessionStatusDateTime": "2019-01-03T11:09:39Z", "SelfTradePrevention": false, "QuantityIncrement": 1.0e-08
			}, 
			{	
				"OMSId": 1, "InstrumentId": 2, "Symbol": "ETHUSD", "Product1": 3, "Product1Symbol": "ETH",
				"Product2": 2, "Product2Symbol": "USD", "InstrumentType": "Standard", "VenueInstrumentId": 2,
				"VenueId": 1, "SortIndex": 0, "SessionStatus": "Running", "PreviousSessionStatus": "Stopped",
				"SessionStatusDateTime": "2018-12-31T12:48:19Z", "SelfTradePrevention": false, "QuantityIncrement": 1.0e-08
			}, 
			{	
				"OMSId": 1, "InstrumentId": 3, "Symbol": "LTCUSD", "Product1": 4, "Product1Symbol": "LTC",
				"Product2": 2, "Product2Symbol": "USD", "InstrumentType": "Standard", "VenueInstrumentId": 3,
				"VenueId": 0, "SortIndex": 0, "SessionStatus": "Running", "PreviousSessionStatus": "Stopped",
				"SessionStatusDateTime": "2018-12-31T09:16:57Z", "SelfTradePrevention": false, "QuantityIncrement": 1.0e-08
			}, 
			{	
				"OMSId": 1, "InstrumentId": 4, "Symbol": "DNUDNU", "Product1": 77, "Product1Symbol": "DNU",
				"Product2": 77, "Product2Symbol": "DNU", "InstrumentType": "Standard", "VenueInstrumentId": 34,
				"VenueId": 1, "SortIndex": 0, "SessionStatus": "Unknown", "PreviousSessionStatus": "Unknown",
				"SessionStatusDateTime": "0001-01-01T00:00:00Z", "SelfTradePrevention": false, "QuantityIncrement": 1
			}, 
			{	
				"OMSId": 1, "InstrumentId": 5, "Symbol": "XRPUSD", "Product1": 6, "Product1Symbol": "XRP",
				"Product2": 2, "Product2Symbol": "USD", "InstrumentType": "Standard", "VenueInstrumentId": 5,
				"VenueId": 1, "SortIndex": 0, "SessionStatus": "Unknown", "PreviousSessionStatus": "Unknown",
				"SessionStatusDateTime": "0001-01-01T00:00:00Z", "SelfTradePrevention": false, "QuantityIncrement": 1.0e-08
			}, 
			{	
				"OMSId": 1, "InstrumentId": 6, "Symbol": "XMRUSD", "Product1": 8, "Product1Symbol": "XMR",
				"Product2": 2, "Product2Symbol": "USD", "InstrumentType": "Standard", "VenueInstrumentId": 6,
				"VenueId": 0, "SortIndex": 0, "SessionStatus": "Running", "PreviousSessionStatus": "Stopped",
				"SessionStatusDateTime": "2018-12-17T19:38:13Z", "SelfTradePrevention": false, "QuantityIncrement": 1.0e-08
			},
			{	
				"OMSId": 1, "InstrumentId": 7, "Symbol": "ZECUSD", "Product1": 9, "Product1Symbol": "ZEC",
				"Product2": 2, "Product2Symbol": "USD", "InstrumentType": "Standard", "VenueInstrumentId": 7,
				"VenueId": 1, "SortIndex": 0, "SessionStatus": "Unknown", "PreviousSessionStatus": "Unknown",
				"SessionStatusDateTime": "0001-01-01T00:00:00Z", "SelfTradePrevention": false, "QuantityIncrement": 1.0e-08
			}
		]
	end

	let(:mocked_get_instrument_valid_response) do
		{	
			"OMSId": 1, 
			"InstrumentId": 1, 
			"Symbol": "BTCUSD", 
			"Product1": 1, 
			"Product1Symbol": "BTC", 
			"Product2": 2, 
			"Product2Symbol": "USD", 
			"InstrumentType": "Standard", 
			"VenueInstrumentId": 1, 
			"VenueId": 0, 
			"SortIndex": 0, 
			"SessionStatus": "Running", 
			"PreviousSessionStatus": "Stopped", 
			"SessionStatusDateTime": "2019-01-03T11:09:39Z", 
			"SelfTradePrevention": false, 
			"QuantityIncrement": 1.0e-08
		}
	end

	let(:mocked_subscribe_level1_valid_response) do
		{
			"OMSId": 1,
			"InstrumentId": 1,
			"BestBid": 0.00,
			"BestOffer": 0.00,
			"LastTradedPx": 0.00,
			"LastTradedQty": 0.00,
			"LastTradeTime": 635872032000000000,
			"SessionOpen": 0.00,
			"SessionHigh": 0.00,
			"SessionLow": 0.00,
			"SessionClose": 0.00,
			"Volume": 0.00,
			"CurrentDayVolume": 0.00,
			"CurrentDayNumTrades": 0,
			"CurrentDayPxChange": 0.0,
			"Rolling24HrVolume": 0.0,
			"Rolling24NumTrades": 0.0,
			"Rolling24HrPxChange": 0.0,
			"TimeStamp": 635872032000000000
		}
	end

	let(:mocked_send_order_valid_response) do 
		{
			"status": "Accepted",
			"errormsg": "",
			"OrderId": 123
		}
	end

	let(:mocked_web_autheticate_user_valid_response) do 
		{ 
			"Authenticated": true,
			"SessionToken": "7d0ccf3a-ae63-44f5-a409-2301d80228bc",
			"UserId": 1
		}
	end
	
		context " error response " do 
			it " expect a AlphapointError if doesn't exists" do
				expect {
					web_socket.xzsd
				}.to raise_error(RuntimeError, "Method xzsd not implemented yet")
			end
		end

		context " call API methods " do 
			context "GetProducts" do 
				it " expect to get an array with all products	" do
					allow_any_instance_of(Alphapoint::WebSocket).to receive(:delegate_message).and_yield(mocked_get_products_valid_response)
					response = nil
					web_socket.delegate_message {|resp| response = resp}
					expect(response.size).to eq 1
					expect(response.class.name).to eq "Array"
					expect(response.first[:Product]).to eq "BTC"
					expect(response.first[:ProductId]).to eq 1
				end
			end

			context "GetProduct" do 
				it " expect to get one product represented as a Hash	", focus: true do
					allow_any_instance_of(Alphapoint::WebSocket).to receive(:delegate_message).and_yield(mocked_get_product_valid_response)
					response = nil
					web_socket.delegate_message {|resp| response = resp}
					expect(response.class.name).to eq "Hash"
					expect(response[:Product]).to eq "BTC"
					expect(response[:ProductId]).to eq 1
				end
			end

			context "GetInstruments" do 
				it " expect to get an array with all instruments	" do
					allow_any_instance_of(Alphapoint::WebSocket).to receive(:delegate_message).and_yield(mocked_get_instruments_valid_response)
					response = nil
					web_socket.delegate_message {|resp| response = resp}
					expect(response.size).to eq 7
					expect(response.class.name).to eq "Array"
					expect(response.first[:Symbol]).to eq "BTCUSD"
					expect(response.first[:InstrumentId]).to eq 1
				end
			end

			context "GetIntrument" do 
				it " expect to get one product represented as a Hash ", focus: true do
					allow_any_instance_of(Alphapoint::WebSocket).to receive(:delegate_message).and_yield(mocked_get_instrument_valid_response)
					response = nil
					web_socket.delegate_message {|resp| response = resp}
					expect(response.class.name).to eq "Hash"
					expect(response[:Symbol]).to eq "BTCUSD"
					expect(response[:InstrumentId]).to eq 1
				end
			end

			context "SubscribeLvl1" do 
				it " expect to get ticker represented as a Hash ", focus: true do
					allow_any_instance_of(Alphapoint::WebSocket).to receive(:delegate_message).and_yield(mocked_subscribe_level1_valid_response)
					response = nil
					web_socket.delegate_message {|resp| response = resp}
					expect(response.class.name).to eq "Hash"
					expect(response[:BestBid]).to eq 0.00
					expect(response[:InstrumentId]).to eq 1
				end
			end

			context "SendOrder" do 
				it " expect to order confirmation represented as a Hash ", focus: true do
					allow_any_instance_of(Alphapoint::WebSocket).to receive(:delegate_message).and_yield(mocked_send_order_valid_response)
					response = nil
					web_socket.delegate_message {|resp| response = resp}
					expect(response.class.name).to eq "Hash"
					expect(response[:status]).to eq "Accepted"
					expect(response[:errormsg]).to eq ""
					expect(response[:OrderId]).to eq 123
				end
			end

			context "WebAuthenticateUser" do 
				it " expect to login confirmation represented as a Hash ", focus: true do
					allow_any_instance_of(Alphapoint::WebSocket).to receive(:delegate_message).and_yield(mocked_web_autheticate_user_valid_response)
					response = nil
					web_socket.delegate_message {|resp| response = resp}
					expect(response.class.name).to eq "Hash"
					expect(response[:Authenticated]).to eq true
					expect(response[:SessionToken]).to eq "7d0ccf3a-ae63-44f5-a409-2301d80228bc"
					expect(response[:UserId]).to eq 1
				end
			end
		end
  end
end
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
		    Alphapoint.configure do |config|
		      config.address = "wss://api_apexqa.alphapoint.com/WSGateway/"
		    end
		end

	  	it "expect a to create object with configurations options" do 
	  		expect {
	  			Alphapoint::WebSocket.new
	  		} .not_to raise_error
	  	end

		it "expect a to create object with a address passed in constructor" do 
	  		web_socket = Alphapoint::WebSocket.new("wss://example.api_apexqa.alphapoint.com/WSGateway/")
	  		expect(web_socket.address).to eq("wss://example.api_apexqa.alphapoint.com/WSGateway/")
	  	end

	end

  end

  context "Resquest to atomic functions " do 

  	before(:all) do
	    Alphapoint.configure do |config| config.address = "wss://api_apexqa.alphapoint.com/WSGateway/" end
	end

	let(:web_socket) do 
		Alphapoint::WebSocket.new
	end

	let(:mocked_get_products_valid_response) {[
			{"OMSId": 1, "ProductId": 1, "Product": "BTC", "ProductFullName": "Bitcoin", "ProductType": "CryptoCurrency", "DecimalPlaces": 8, "TickSize": 1.0, "NoFees": false}
		]
	}

	let(:mocked_get_product_valid_response) {
			{"OMSId": 1, "ProductId": 1, "Product": "BTC", "ProductFullName": "Bitcoin", "ProductType": "CryptoCurrency", "DecimalPlaces": 8, "TickSize": 1.0, "NoFees": false}
	}
	
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
		end
  end
end
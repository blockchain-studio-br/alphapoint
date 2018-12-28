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

  context "add actions" do 

  	before(:all) do
	    Alphapoint.configure do |config|
	      config.address = "wss://api_apexqa.alphapoint.com/WSGateway/"
	    end

	    @websocket = Alphapoint::WebSocket.new
	end

  	context "register actions" do

  		it "expect save actions inherit  Alphapoint::Call::Base" do 
	  		expect {
	  			class RequestCommand < Alphapoint::Call::Base; end

	  			@websocket.register_action(RequestCommand.new)
	  		} .not_to raise_error
	  	end

	  	it "expect avoid actions that class is Alphapoint::Call::Base" do 
	  		expect {
	  			@websocket.register_action(Alphapoint::Call::Base.new)
	  		}.to raise_error(Alphapoint::AlphapointError, "Actions need to inherit Alphapoint::Call::Base")
	  	end

	  	it "expect avoid actions not inherit Alphapoint::Call::Base" do 
	  		expect {
	  			@websocket.register_action(Object.new)
	  		}.to raise_error(Alphapoint::AlphapointError, "Actions need to inherit Alphapoint::Call::Base")
	  	end
  	end

  	context "execute actions" do 

  		before(:all) do
		    Alphapoint.configure do |config|
		      config.address = "wss://api_apexqa.alphapoint.com/WSGateway/"
		    end

		    @websocket = Alphapoint::WebSocket.new
		end

		context "requests" do

	  		it "expect to execute method finish" do
	  			
  				class GetProducts < Alphapoint::Call::Base
					@@call_name = 'GetProducts'

					def handle_response(data)		
						#p(data)
					end
				end

				class GetInstruments < Alphapoint::Call::Base
					@@call_name = 'GetInstruments'

					def handle_response(data)		
						#p(data)
					end
				end

				@websocket.register_action(GetProducts.new({ OMSid: 1}, Alphapoint::Call::REQUEST))
				@websocket.register_action(GetProducts.new({ OMSid: 1}, Alphapoint::Call::REQUEST))

	  			expect(@websocket.execute_requests).to be_truthy
	  		end


  		end

  	end 
  end

end
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

  		it "expect save actions inherit  Alphapoint::Base" do 
	  		expect {
	  			class RequestCommand < Alphapoint::Base

	  			end

	  			@websocket.register_action(RequestCommand.new)
	  		} .not_to raise_error
	  	end

	  	it "expect avoid actions that class is Alphapoint::Base" do 
	  		expect {
	  			@websocket.register_action(Alphapoint::Base.new)
	  		}.to raise_error(Alphapoint::AlphapointError, "Actions need to inherit Alphapoint::Base")
	  	end

	  	it "expect avoid actions not inherit Alphapoint::Base" do 
	  		expect {
	  			@websocket.register_action(Object.new)
	  		}.to raise_error(Alphapoint::AlphapointError, "Actions need to inherit Alphapoint::Base")
	  	end
  	end
  end

end
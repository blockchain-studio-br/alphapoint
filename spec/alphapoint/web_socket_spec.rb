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

end
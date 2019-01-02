require "spec_helper"

# RSpec.describe Alphapoint::GetProducts do

#   let(:address) {"wss://api_apexqa.alphapoint.com/WSGateway/"}
#   let(:ws) {Faye::WebSocket::Client.new(address)}
#   let(:mocked_valid_response) {
#     [
#       Alphapoint::GetProductsResponse.new(
#         1, 1, "BTC", "Bitcoin", "aaa", 2,1,false)
#     ]
#   }
  

#   describe "#on_message" do
#     context "when websocket returns a valid response" do
#       it "should returns a valid response" do
#         allow_any_instance_of(Alphapoint::GetProducts).to receive(:on_message).and_yield(mocked_valid_response)
#         response = nil
#         Alphapoint::GetProducts.new.on_message {|resp| response = resp}
#         expect(response.size).to eq 1
#         expect(response.first.product).to eq "BTC"
#       end
#     end
#   end


# end

module Alphapoint 
  class GetProducts
    
    def initialize
      @payload = {
          "OMSId": 1
      }
      @frame = {
          'm': 0,
          'i': 2,
          'n': 'GetProducts',
          'o': @payload.to_json
      }
    end

    def execute(ws, &block)
      response = [] 
      puts "lalalalla"
      ws.send(@frame.to_json)
      ws.on :message do |event|
        # puts "to aqui dentro do on_message: #{event.data}"
        products_json = JSON.parse(event.data)
        JSON.parse(products_json["o"]).each do |product_json|
          # puts product_json
          # {\"OMSId\":1,\"ProductId\":1,
          # \"Product\":\"BTC\",
          # \"ProductFullName\":\"Bitcoin\",
          # \"ProductType\":\"CryptoCurrency\",
          # \"DecimalPlaces\":8,
          # \"TickSize\":0.00000001,
          # \"NoFees\":false}
          response << GetProductsResponse.new(
            product_json["OMSId"],
            product_json["Product"],
            product_json["ProductFullName"],
            product_json["ProductType"],
            product_json["DecimalPlaces"],
            product_json["TickSize"],
            product_json["NoFees"]
          )
        end
        block.call(response)
      end
    end

    def handle_response(response)
      return {
        "a": 1
      }
    end
  end
  
  class GetProductsResponse < Struct.new(:oms_id, :product_id, :product, :product_full_name, :product_type, :decimal_places,:tick_size,:no_fees )
   
  end
end
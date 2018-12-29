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
      responses = []
      ws.send(@frame.to_json)
      ws.on :message do |event|
        products_json = JSON.parse(event.data)
        JSON.parse(products_json["o"]).each do |product_json|
          responses << GetProductsResponse.new(product_json["OMSId"],product_json["Product"],product_json["ProductFullName"],product_json["ProductType"],product_json["DecimalPlaces"],product_json["TickSize"],product_json["NoFees"])
        end
        block.call(responses)
      end
    end
  end
  
  class GetProductsResponse < Struct.new(:oms_id, :product_id, :product, :product_full_name, :product_type, :decimal_places,:tick_size,:no_fees )
   
  end
end
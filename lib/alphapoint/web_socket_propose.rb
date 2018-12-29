module Alphapoint 
  class WebSocketPropose

    def initialize(address = "wss://api_apexqa.alphapoint.com/WSGateway/")

      @actions = [Alphapoint::GetProducts.new]

      @address = address
      
      Thread.new { EM.run {
                    @ws = Faye::WebSocket::Client.new(@address)
                    @ws.on :open do |event|
                      p [:open, "Websocket connected to #{@address}"]
                    end
                    @ws.on :close do |event|
                      p [:close]
                    end
                } 
      }
      trap(:INT) { EM.stop }
      trap(:TERM){ EM.stop }

      while not EM.reactor_running?; end

      while not EM.defers_finished?; end
    end

    # esse método serve para o usuário chamar o websocket
    # desse jeito ele consegue fazer algo assim: alp.get_products_propose por exemplo
    def method_missing(m, *args, &block) 
      respond_action = @actions.select{|action| action.class.name.split('::').last.underscore == m.to_s}
      if respond_action.size > 0
        puts "Delegating to action: #{m}"
        respond_action.first.send("execute", @ws) do |response|
          block.call(response)
        end
      else
        raise "Method #{m} not implemented yet"
      end
    end

  end
end
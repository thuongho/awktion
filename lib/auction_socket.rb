class AuctionSocket

  # middleware to inject into the application
  def initialize app
    @app = app
  end

  # env contains info on the request
  def call env
    @env = env
    # assert if the request is from a websocket
    if socket_request?
      # feed the websocket with env which will give enough info to communicate with it
      socket = Faye::WebSocket.new env

      socket.on :open do # block is executed when socket is created
        socket.send "Hello!"
      end

      # return socket rack response in order for connection on client to finish
      # acknowledgement that the websocket has been established
      socket.rack_response
    
    else # drain remaining out of middleware
      @app.call env
    end
  end

  private

  # attr_reader so that we don't have to keep using @env all the time
  attr_reader :env

  def socket_request?
    Faye::WebSocket.websocket? env
  end
end
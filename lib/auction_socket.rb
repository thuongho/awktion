# need to require lib/place_bid.rb to use PlaceBid.new
require File.expand_path "../place_bid", __FILE__

class AuctionSocket

  # middleware to inject into the application
  def initialize app
    @app = app
    # gather a list of all clients
    @clients = []
  end

  # env contains info on the request
  def call env
    @env = env
    # assert if the request is from a websocket
    if socket_request?
      socket = spawn_socket

      # build the connected clients list
      @clients << socket

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

  def spawn_socket
    # feed the websocket with env which will give enough info to communicate with it
    socket = Faye::WebSocket.new env

    socket.on :open do # block is executed when socket is created
      socket.send "Hello!"
    end

    socket.on :message do |event|
      socket.send event.data # event.data are auction_id user_id bid_value
      begin
        tokens = event.data.split " "
        operation = tokens.delete_at 0

        case operation
        when "bid"
          bid socket, tokens
        end

      rescue Exception => e
        p e
        p e.backtrace
      end
    end

    return socket
  end

  def bid socket, tokens
    # PlaceBid requires 3 args which will be from tokens
    service = PlaceBid.new(
      auction_id: tokens[0],
      user_id: tokens[1],
      value: tokens[2]
    )

    # add logic to bidding
    if service.execute
      socket.send "bidok"
      notify_outbids socket, tokens[2]
    else
      if service.status == :won
        # pass in socket because we want to notify the winner and the rest lost
        notify_auction_ended socket
      else
        # in the auction_websocketjs we have value being pass, so include that to update the bid value
        # socket.send "underbid #{tokens[2]}"
        socket.send "underbid #{service.auction.current_bid}"
      end
    end
  end

  def notify_outbids socket, value
    # the client that match our socket, we are going to reject
    @clients.reject { |client| client == socket }.each do |client|
      client.send "outbid #{value}"
    end
  end

  def notify_auction_ended socket
    socket.send "won"
    @clients.reject { |client| client == socket }.each do |client|
      client.send "lost"
    end
  end
end
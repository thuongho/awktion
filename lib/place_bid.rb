# a class to make sure that new bids are not less than current bid
class PlaceBid
  def initialize options
    @value = options[:value]
    @user_id = options[:user_id]
    @auction_id = options[:auction_id]
  end

  def execute
    # find the auction by the auction id
    auction = Auction.find @auction_id
    # instantiate a new bid using the value and user id
    # a new bid that is build around the auction and user id
    bid = auction.bids.build value: @value, user_id: @user_id

    if bid.save
      return true
    end
  end
end
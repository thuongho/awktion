# a class to make sure that new bids are not less than current bid
class PlaceBid
  # makes that auction variable public to the outside
  attr_reader :auction, :status

  def initialize options
    @value = options[:value].to_f
    @user_id = options[:user_id].to_i
    @auction_id = options[:auction_id].to_i
  end

  def execute
    # find the auction by the auction id
    # instance variable to make it avail
    @auction = Auction.find @auction_id

    # debugging - make sure that code below desn't execute
    # binding.pry
    # add status to end of auction
    if auction.ended? && auction.top_bid.user_id == @user_id
      @status = :won
      return false
    end

    # prevent the bid object to be created if value is less than current bid
    if @value <= auction.current_bid
      return false
    end

    # instantiate a new bid using the value and user id
    # a new bid that is build around the auction and user id
    bid = auction.bids.build value: @value, user_id: @user_id

    if bid.save
      return true
    else 
      # return false in case cannot save
      return false
    end
  end
end
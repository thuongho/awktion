require "test_helper"
# need to use the library of lib/place_bid.rb
require "place_bid"

class PlaceBidTest < MiniTest::Test
  def setup
    @user = User.create! email: "sample@awktion.com", password: "password"
    @another_user = User.create! email: "another_user@awktion.com", password: "password"
    @product = Product.create! name: "Some Product"
    @auction = Auction.create! value: 10, product_id: product.id
  end

  def test_it_places_a_bid
    # placing the bid
    # instantiate a new service to place bid
    # insert a new bid value, attach to the user id of another user, and add auction id
    # value, user_id, auction_id needs to be defined in lib/place_bid.rb
    service = PlaceBid.new(
      value: 11, 
      user_id: another_user.id, 
      auction_id: auction.id
    )

    service.execute

    # let's say we want to bid 1 dollar above the auction value
    assert_equal 11, auction.current_bid
  end

  def test_fails_to_place_bid_under_current_value
    service = PlaceBid.new(
      value: 9,
      user_id: another_user.id,
      auction_id: auction.id
    )

    # assert false
    # refute: fails if a test is true value
    refute service.execute, "Your bid is below the current bid."
  end

  def test_notifies_if_auction_has_won
    service = PlaceBid.new(
      value: 15,
      user_id: another_user.id,
      auction_id: auction.id
    )

    service.execute

    another_service = PlaceBid.new(
      value: 9000,
      user_id: another_user.id,
      auction_id: auction.id
    )

    another_service.execute

    assert_equal service.status, :won
  end

  private

  # make sure the variables in setup are publicly avail
  attr_reader :user, :another_user, :product, :auction
end
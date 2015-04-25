require "test_helper"
# need to use the library of lib/place_bid.rb
require "place_bid"

class PlaceBidTest < MiniTest::Test
  def test_it_places_a_bid
    user = User.create! email: "sample@awktion.com", password: "password"
    another_user = User.create! email: "another_user@awktion.com", password: "password"
    product = Product.create! name: "Some Product"
    auction = Auction.create! value: 10, product_id: product.id

    # placing the bid
    # instantiate a new service to place bid
    # insert a new bid value, attach to the user id of another user, and add auction id
    # value, user_id, auction_id needs to be defined in lib/place_bid.rb
    service = PlaceBid.new value: 11, user_id: another_user, auction_id: auction.id

    service.execute

    # let's say we want to bid 1 dollar above the auction value
    assert_equal 11, auction.current_bid
  end
end
class Product < ActiveRecord::Base
  belongs_to :user
  # now product has access to auctions
  has_one :auction

  def has_auction?
    # because of has_one :auction, we can now call on auction
    # go to the relationship, fetch the auction and see if it exists
    auction.present?
  end
end

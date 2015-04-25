class Auction < ActiveRecord::Base
  belongs_to :product
  # bids implemented in the auction
  has_many :bids

  def top_bid
    bids.order(value: :desc).first
  end
end

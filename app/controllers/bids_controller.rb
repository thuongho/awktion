require "place_bid"

class BidsController < ApplicationController

  def create
    service = PlaceBid.new bid_params
    # if the service executes successfully, redirect to product page
    # passing in product_id params, that way we don't need to go to db and fetch another product
    if service.execute
      redirect_to product_path(params[:product_id]), notice: "Your bid went through."
    else
      redirect_to product_path(params[:product_id]), alert: "Your bid was not successful."
    end
  end

  private

  def bid_params
    # requiring the bid object and only permitting the value
    # merge additional data user id, auction id (params in URL)
    params.require(:bid).permit(:value).merge!(
      user_id: current_user.id,
      auction_id: params[:auction_id]
    )
  end
end

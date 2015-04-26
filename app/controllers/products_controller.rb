class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @products = Product.all
  end

  def show
  end

  def new
    @product = Product.new
    respond_with(@product)
  end

  def edit
  end

  def create
    @product = Product.new(product_params.merge! user_id: current_user.id)
    @product.save
    respond_with(@product)
  end

  def update
    @product.update(product_params)
    respond_with(@product)
  end

  def destroy
    @product.destroy
    respond_with(@product)
  end

  def transfer
    # only id in params because only have id in the route
    product = Product.find params[:id]

    # only transfer if the auction ended.
    if product.auction.ended?
      product.update_attribute :user_id, product.auction.top_bid.user_id
      # product is the same as product_path
      redirect_to product, notice: "Successfully transferred the product."
    else
      redirect_to product, alert: "The auction hasn't ended yet."
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:name, :image)
    end
end

class ProductsController < ApplicationController
  before_filter :require_login
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :set_admin
  after_filter :verify_authorized

  def index
    authorize(Product)
    @products = Product.all.order('created_at DESC')
  end

  def show
  end

  def new
    @product = Product.new
    authorize(@product)
  end

  def edit
  end

  def create
    @product = Product.new(product_params)
    authorize(@product)

    if @product.save
      redirect_to @product, notice: 'Product was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if @product.update(product_params)
      redirect_to @product, notice: 'Product was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @product.destroy
    redirect_to products_url, notice: 'Product was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_product
    @product = Product.find(params[:id])
    authorize(@product)
  end

  # Only allow a trusted parameter "white list" through.
  def product_params
    params.require(:product).permit(:name, :price, :kind, :course_id)
  end
end

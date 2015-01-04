class CartsController < ApplicationController
  before_action :require_sign_up
  before_action :set_cart, except: [:index]
  before_action :set_product, only: [:add_product, :remove_product]
  before_action :set_admin, except: [:update, :show]
  after_filter :verify_authorized

  def index
    authorize(Cart)
    @carts = Cart.all
  end

  def show
    authorize(@cart)
    @order = Order.new
    @order_total = processor.order_total
    render :show, :layout => "layouts/cart"
  end

  def add_product
    authorize(@cart, :update?)

    if processor.add_product(@product)
      track_event 'orders.new', course: @product.name
    else
      message = @cart.errors.full_messages.to_sentence
      flash[:error] = message
    end
    redirect_to user_cart_path
  end

  def remove_product
    authorize(@cart, :update?)

    unless processor.remove_product(@product)
      flash[:error] = @cart.errors.full_messages.to_sentence
    end

    redirect_to user_cart_path
  end

  def add_coupon
    authorize(@cart, :update?)
    code = params[:code]
    coupon = Coupon.find_by(code: code)
    if coupon && coupon.decorate.coupon_valid?
      @cart.coupon = coupon
      flash[:notice] = 'Coupon added'
    else
      @cart.coupon = nil
      flash[:error] = 'Coupon code not valid'
    end
    @cart.save!
    redirect_to cart_path
  end

  def destroy
    authorize(@cart)
    @cart.destroy!
    redirect_to carts_url, notice: 'Cart was successfully destroyed.'
  end

  private

  def set_cart
    if current_user.admin? && params[:id]
      @cart = Cart.find(params[:id])
    else
      @cart = current_user.cart || current_user.build_cart
    end
  end

  def set_product
    @product = Product.find params[:product_id]
    @course = @product.course
  end

  def processor
    @processor ||= OrderProcessor.new(@cart, nil, params[:experiments])
  end
end

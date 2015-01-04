class Api::V1::CartsController < Api::V1::BaseController
  respond_to :json
  before_action :set_cart
  before_action :set_coupon

  # GET /api/v1/users/uid/cart
  def show
    authorize(@cart, :api_show?)
  end

  # PUT /api/v1/users/uid/cart
  #     coupon: { code: 'asdf' }
  def update
    authorize(@cart, :api_update?)
    code = cart_params[:coupon][:code]
    coupon = Coupon.find_by(code: code)
    if coupon && coupon.decorate.coupon_valid?
      @cart.coupon = coupon
      if @cart.save
        head :ok
      else
        # TODO: report error?
        head :bad_request
      end
    else
      head :bad_request
    end
  end

  # PUT /api/v1/users/:user_id/cart/add_coupon
  def add_coupon
    authorize(@cart, :api_update?)
    coupon = Coupon.where(code: coupon_params[:code]).first
    if !coupon.blank? && coupon.decorate.coupon_valid?
      @cart.coupon = coupon
      @cart.save!
      render template: 'api/v1/carts/cart_show', status: 200
    else
      @cart.coupon = nil
      @cart.save!
      @error = { message: 'The coupon could not be added' }
      render template: 'api/v1/carts/error', status: 401
    end
  end


  private

  def set_cart
    @cart = current_user.cart
  end

  def set_coupon
    @coupon = @cart.coupon
  end

  def cart_params
    params.require(:cart).permit(:coupon => [:code])
  end

  def coupon_params
    params.require(:coupon).permit(:code)
  end

end

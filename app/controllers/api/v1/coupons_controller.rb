class Api::V1::CouponController < Api::V1::BaseController
  respond_to :json
  before_action :set_coupon

  def show
    if @coupon
      @coupon.to_json
    else
      head :not_found
    end
  end

  private

  def set_coupon
    @coupon = Coupon.find_by code: coupon_params[:code]
  end

  def coupon_params
    params.require(:coupon).permit(:code)
  end
end

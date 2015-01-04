class CouponsController < ApplicationController
  before_action :set_course
  before_action :set_admin
  before_action :set_coupon, except: [:new, :index, :create]
  after_filter :verify_authorized

  def index
    authorize(Coupon)
    @coupons = @course.coupons
  end

  def show
    authorize(@coupon)
  end

  def new
    @coupon = @course.coupons.build
    authorize(@coupon)
  end

  def edit
    authorize(@coupon)
  end

  def create
    @coupon = @course.coupons.build(coupon_params)
    authorize(@coupon)

    if @coupon.save
      redirect_to course_coupons_path(@course), notice: 'Coupon was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    authorize(@coupon)
    if @coupon.update(coupon_params)
      redirect_to course_coupons_path(@course), notice: 'Coupon was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    authorize(@coupon)
    @coupon.destroy
    redirect_to course_coupons_path(@course), notice: 'Coupon was successfully destroyed.'
  end


  private

  def set_coupon
    @coupon = Coupon.find(params[:id])
  end

  def set_course
    @course = Course.friendly.find(params[:course_id]).decorate
  end

  # Only allow a trusted parameter "white list" through.
  def coupon_params
    params.require(:coupon).permit(:code, :expires_at, :max_redemptions, :price)
  end
end

class CouponDecorator < Draper::Decorator
  delegate_all

  def coupon_valid?
    (redemptions.to_i < max_redemptions.to_i) && (expires_at >= Time.now)
  end

  def redeem!
    # raise Coupon::CouponInvalidError unless coupon_valid?
    self.redemptions ||= 0
    self.redemptions += 1
    save
  end

  private

  class Coupon::CouponInvalidError < StandardError; end

end

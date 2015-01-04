require 'spec_helper'

describe CouponDecorator do
  describe '#coupon_valid?' do
    let(:coupon) { build(:coupon, max_redemptions: 2).decorate }

    it 'is valid if redemptions are not used up' do
      coupon.redemptions = 1
      expect(coupon.coupon_valid?).to be_true
    end

    it 'is not valid if redemptions are used up' do
      coupon.redemptions = 2
      expect(coupon.coupon_valid?).to be_false
    end
  end
end

class AddCouponToCart < ActiveRecord::Migration
  def change
    add_reference :carts, :coupon, index: true
  end
end

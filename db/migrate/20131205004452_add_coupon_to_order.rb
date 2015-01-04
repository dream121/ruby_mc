class AddCouponToOrder < ActiveRecord::Migration
  def change
    add_reference :orders, :coupon, index: true
  end
end

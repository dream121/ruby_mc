require 'spec_helper'

describe "coupons/edit" do
  let(:course) { build_stubbed(:course) }
  let(:coupon) { build_stubbed(:coupon, course: course) }

  before(:each) do
    assign(:course, course)
    assign(:coupon, coupon)
  end

  it "renders the edit coupon form" do
    render

    assert_select "form", action: course_coupon_path(course, coupon), method: "post" do
      assert_select "input#coupon_code", name: "coupon[code]"
      assert_select "input#coupon_max_redemptions", name: "coupon[max_redemptions]"
      assert_select "input#coupon_price", name: "coupon[price]"
    end
  end
end

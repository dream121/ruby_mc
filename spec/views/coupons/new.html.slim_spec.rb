require 'spec_helper'

describe "coupons/new" do
  let(:course) { build_stubbed(:course) }
  before(:each) do
    assign(:course, course)
    assign(:coupon, build_stubbed(:coupon, course: course))
  end

  it "renders new coupon form" do
    render

    assert_select "form", action: course_coupons_path(course), method: "post" do
      assert_select "input#coupon_code", name: "coupon[code]"
      assert_select "input#coupon_max_redemptions", name: "coupon[max_redemptions]"
      assert_select "input#coupon_price", name: "coupon[price]"
    end
  end
end


require 'spec_helper'

describe "coupons/index" do
  let(:course) { build :course }

  before(:each) do
    assign(:course, course)

    assign(:coupons, [
      build_stubbed(:coupon,
        code: "Code",
        redemptions: 1,
        max_redemptions: 2,
        price: 3,
        course: course
      ),
      build_stubbed(:coupon,
        code: "Code",
        redemptions: 1,
        max_redemptions: 2,
        price: 3,
        course: course
      )
    ])
  end

  it "renders a list of coupons" do
    render

    assert_select "tr>td", text: "Code".to_s, count: 2
    assert_select "tr>td", text: 2.to_s, count: 2
    assert_select "tr>td", text: course.title, count: 2
  end
end

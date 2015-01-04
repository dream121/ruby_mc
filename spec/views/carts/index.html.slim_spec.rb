require 'spec_helper'

describe "carts/index" do
  let(:alice) { build_stubbed(:user, name: 'Alice') }
  let(:bob) { build_stubbed(:user, name: 'Bob') }

  let(:carts) {
    [
      create(:cart_with_course, user: alice),
      create(:cart_with_course, user: bob, response: { 'error' => { 'code' => 'big_fail' } })
    ]
  }

  before(:each) do
    allow(view).to receive(:policy).and_return double(destroy?: true)
    assign(:carts, carts)
  end

  it "renders a list of carts" do
    render

    assert_select "tr td", text: 'Alice'
    assert_select "tr td", text: 'Bob'
    assert_select "tr td", text: /A Course Product/
    assert_select "tr td", text: 'big_fail'
  end
end

require 'spec_helper'

describe "orders/edit" do
  before(:each) do
    @order = assign(:order, build_stubbed(:order))
  end

  it "renders the edit order form" do
    render

    assert_select "form", action: orders_path(@order), method: "post"
  end
end

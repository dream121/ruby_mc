require 'spec_helper'

describe "orders/show" do
  before(:each) do
    view.stub(:policy).and_return double(:policy, edit?: true, destroy?: true, index?: true)
    @order = assign(:order, create(:order))
  end

  it "renders attributes" do
    render

    expect(rendered).to match(/Tom Middleton/)
    expect(rendered).to match(/Baking Bread/)
  end
end

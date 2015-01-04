require 'spec_helper'

describe "orders/index" do
  before(:each) do

    allow(view).to receive(:policy).and_return double(destroy?: true)

    alice = create(:user, name: 'Alice')
    bob = create(:user, name: 'Bob')

    assign(:orders, [
      create(:order, user: alice),
      create(:order, user: bob)
    ])
  end

  it "renders a list of orders" do
    render
    assert_select "tr td", text: 'Alice'
    assert_select "tr td", text: 'Bob'
    assert_select "tr td", text: /A Course/
  end
end

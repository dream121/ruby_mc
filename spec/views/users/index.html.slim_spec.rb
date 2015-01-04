require 'spec_helper'

describe "users/index" do
  before(:each) do
    view.stub(:policy).and_return double(:policy, edit?: true, destroy?: true)
    assign(:users, [
      build(:user)
    ])
  end

  it "renders a list of users" do
    render
    assert_select "tr>td", text: "Tom Middleton".to_s
  end
end

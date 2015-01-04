require 'spec_helper'

describe "users/show" do
  before(:each) do
    view.stub(:policy).and_return double(:policy, edit?: true, destroy?: true)
    @user = assign(:user, build_stubbed(:user))
  end

  it "renders attributes" do
    render

    expect(rendered).to match(/#{@user.name}/)
    expect(rendered).to match(/Email/)
    expect(rendered).to match(/admin/)
  end
end

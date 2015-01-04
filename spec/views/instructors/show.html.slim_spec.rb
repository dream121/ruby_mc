require 'spec_helper'

describe "instructors/show" do
  before(:each) do
    view.stub(:policy).and_return double(:policy, edit?: true, destroy?: true)
    @instructor = assign(:instructor, build_stubbed(:instructor))
  end

  it "renders attributes" do
    render

    expect(rendered).to match(/Alton Brown/)
  end
end

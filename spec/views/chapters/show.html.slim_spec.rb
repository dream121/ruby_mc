require 'spec_helper'

describe "chapters/show" do
  before(:each) do
    view.stub(:policy).and_return double(:policy, edit?: true)
    @chapter = assign(:chapter, build_stubbed(:chapter))
    @course = assign(:course, build_stubbed(:course))
  end

  it "renders attributes" do
    render

    expect(rendered).to match(/1/)
    expect(rendered).to match(/Duration/)
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/Brightcove/)
  end
end

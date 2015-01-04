require 'spec_helper'

describe "courses/show" do
  before(:each) do
    view.stub(:policy).and_return double(:policy, edit?: true, destroy?: true, watch?: true)

    @course = assign(:course, build_stubbed(:course).decorate)
    @course.stub_chain(:instructor, :name).and_return('Rick James')
    @course.stub_chain(:instructor, :long_bio).and_return("I'm Rick James, Sir.")
    @course.stub_chain(:chapters, :order).and_return{[build_stubbed(:chapter)]}
    @course.stub_chain(:chapters, :length).and_return(0)
  end

  it "renders attributes" do
    render

    expect(rendered).to match(/Baking Bread/)
  end
end

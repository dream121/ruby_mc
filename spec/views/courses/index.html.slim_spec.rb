require 'spec_helper'

describe "courses/index" do
  before(:each) do
    view.stub(:policy).and_return double(show_enrolled?: true, show?: true)
    assign(:courses, [
      build_stubbed(:course,
        title: "Course A"
      ),
      build_stubbed(:course,
        title: "Course B"
      )
    ])
  end

  it "renders a list of courses" do
    render

    assert_select "span", text: "Course A".to_s, count: 1
    assert_select "span", text: "Course B".to_s, count: 1
  end
end

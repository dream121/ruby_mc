require 'spec_helper'

describe "courses/index_enrolled" do
  before(:each) do
    allow(view).to receive(:policy).and_return double(show?: true)

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

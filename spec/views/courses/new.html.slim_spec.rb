require 'spec_helper'

describe "courses/new" do
  before(:each) do
    view.stub(:policy).and_return double(:policy, destroy?: true)
    assign(:course, build_stubbed(:course))
  end

  it "renders new course form" do
    render

    assert_select "form", action: courses_path, method: "post" do
      assert_select "input#course_title", name: "course[title]"
      assert_select "input#course_detail_attributes_role", name: "course[detail_attributes][role]"
      assert_select "input#course_detail_attributes_skill", name: "course[detail_attributes][skill]"
    end
  end
end


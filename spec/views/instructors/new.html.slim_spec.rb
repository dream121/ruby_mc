require 'spec_helper'

describe "instructors/new" do
  before(:each) do
    assign(:instructor, build_stubbed(:instructor))
  end

  it "renders new instructor form" do
    render

    assert_select "form", action: instructors_path, method: "post" do
      assert_select "input#instructor_name", name: "instructor[name]"
      assert_select "textarea#instructor_short_bio", name: "instructor[short_bio]"
      assert_select "textarea#instructor_long_bio", name: "instructor[long_bio]"
    end
  end
end


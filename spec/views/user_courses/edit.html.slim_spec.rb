require 'spec_helper'

describe "user_courses/edit" do
  before(:each) do
    @user_course = assign(:user_course, build_stubbed(:user_course))
  end

  it "renders the edit user_course form" do
    render

    assert_select "form", action: user_user_course_path(@user_course.user, @user_course), method: "post" do
      assert_select "input#user_course_access", name: "user_course[access]"
    end
  end
end

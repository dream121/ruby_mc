require 'spec_helper'

describe "users/edit" do
  before(:each) do
    @user = assign(:user, build_stubbed(:user))
    @instructors = assign(:instructors, [build_stubbed(:instructor)])
  end

  it "renders the edit user form" do
    render

    assert_select "form", action: users_path(@user), method: "post" do
      assert_select "input#user_name", name: "user[name]"
      assert_select "input#user_email", name: "user[email]"
      assert_select "input#user_permissions_admin", name: "user[permissions][admin]"
      assert_select "input#user_permissions_comments", name: "user[permissions][comments]"
    end
  end
end

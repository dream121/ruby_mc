require 'spec_helper'

describe "email_templates/edit" do
  before(:each) do
    @course = assign(:course, build_stubbed(:course).decorate)
    @email_template = assign(:email_template, build_stubbed(:email_template, course: @course))
    @subject_preview = assign(:subject_preview, "A Subject")
    @body_preview = assign(:body_preview, "Hello World")
  end

  it "renders the edit email_template form" do
    render

    assert_select "form", action: course_email_templates_path(@course, @email_template), method: "post" do
      assert_select "input#email_template_from", name: "email_template[from]"
      assert_select "input#email_template_subject", name: "email_template[subject]"
      assert_select "textarea#email_template_body", name: "email_template[body]"
      assert_select "select#email_template_kind", name: "email_template[kind]"
    end
  end
end

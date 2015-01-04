require 'spec_helper'

describe "email_templates/new" do
  let(:course) { build_stubbed(:course).decorate }

  before(:each) do
    assign(:course, course)
    assign(:email_template, build_stubbed(:email_template))
  end

  it "renders new email_template form" do
    render

    assert_select "form", action: course_email_templates_path(@course), method: "post" do
      assert_select "input#email_template_from", name: "email_template[from]"
      assert_select "input#email_template_subject", name: "email_template[subject]"
      assert_select "textarea#email_template_body", name: "email_template[body]"
      assert_select "select#email_template_kind", name: "email_template[kind]"
    end
  end
end


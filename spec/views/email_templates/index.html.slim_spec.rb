require 'spec_helper'

describe "email_templates/index" do
  let(:course) { build :course }

  before(:each) do
    assign(:course, course)

    assign(:email_templates, [
      build_stubbed(:email_template,
        from: "From",
        subject: "Subject",
        body: "MyText",
        course: course,
        kind: "Kind"
      ),
      build_stubbed(:email_template,
        from: "From",
        subject: "Subject",
        body: "MyText",
        course: course,
        kind: "Kind"
      )
    ])
  end

  it "renders a list of email_templates" do
    render

    assert_select "tr>td", text: "From".to_s, count: 2
    assert_select "tr>td", text: "Subject".to_s, count: 2
    assert_select "tr>td", text: "Kind".to_s, count: 2
  end
end

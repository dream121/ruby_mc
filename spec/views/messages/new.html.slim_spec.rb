require 'spec_helper'

describe "messages/new" do
  let(:course) { build_stubbed(:course) }

  before(:each) do
    assign(:message, Message.new)
    assign(:course, course)
  end

  it "renders new message form" do
    render

    assert_select "form", action: course_messages_path(course), method: "post" do
    end
  end
end


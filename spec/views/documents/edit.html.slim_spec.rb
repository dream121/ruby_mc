require 'spec_helper'

describe "documents/edit" do
  let(:course) { build_stubbed(:course).decorate }

  before(:each) do
    assign(:parent, course)
    @document = assign(:document, build_stubbed(:document))
  end

  it "renders the edit document form" do
    render

    assert_select "form", action: course_document_path(course, @document), method: "post" do
      assert_select "input#document_kind", name: "document[kind]"
    end
  end
end

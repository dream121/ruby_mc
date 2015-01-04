require 'spec_helper'

describe "documents/new" do
  let(:course) { build_stubbed(:course).decorate }

  before(:each) do
    assign(:parent, course)
    assign(:document, build_stubbed(:document))
  end

  it "renders new document form" do
    render

    assert_select "form", action: course_documents_path(course), method: "post" do
      assert_select "input#document_kind", name: "document[kind]"
    end
  end
end


require 'spec_helper'

describe "images/new" do
  let(:course) { build_stubbed(:course).decorate }
  let(:image) { build_stubbed(:image) }

  before(:each) do
    assign(:parent, course)
    assign(:image, image)
    assign(:form_path, "theformurlpath")
    assign(:image_resource, [course, image])
  end

  it "renders new image form" do
    render
    assert_select "form", action: course_images_path(course), method: "post" do
      assert_select "select#image_kind", name: "image[kind]"
    end
  end
end


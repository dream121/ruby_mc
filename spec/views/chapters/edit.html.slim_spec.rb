require 'spec_helper'

describe "chapters/edit" do

  let(:course) { build_stubbed(:course).decorate }

  before(:each) do
    @chapter = assign(:chapter, build_stubbed(:chapter))
    assign(:course, course)
  end

  it "renders the edit chapter form" do
    render

    assert_select "form", action: course_chapters_path(course, @chapter), method: "post" do
      assert_select "input#chapter_number", name: "chapter[number]"
      assert_select "input#chapter_duration", name: "chapter[duration]"
      assert_select "input#chapter_title", name: "chapter[title]"
      assert_select "input#chapter_brightcove_id", name: "chapter[brightcove_id]"
    end
  end
end

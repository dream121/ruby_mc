require 'spec_helper'

describe "instructors/index" do
  before(:each) do
    view.stub(:policy).and_return double(:policy, create?: true)

    assign(:instructors, [
      build_stubbed(:instructor,
        name: "Alton Brown",
      ),
      build_stubbed(:instructor,
        name: "James Brown",
      )
    ])
  end

  it "renders a list of instructors" do
    render

    assert_select "tr>td", text: "Alton Brown".to_s
    assert_select "tr>td", text: "James Brown".to_s
  end
end

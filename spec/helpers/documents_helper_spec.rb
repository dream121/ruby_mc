require 'spec_helper'

describe DocumentsHelper do
  describe "set_parent" do

    let(:course_double) { double(:course, decorate: course_decorated_double) }
    let(:course_decorated_double) { double(:decorated) }

    before do
      params['course_id'] = 'my-course'
      Course.stub_chain(:friendly, :find).with(anything).with('my-course').and_return course_double
    end

    it "sets the parent specified by params" do
      expect(helper.set_parent).to eq(course_decorated_double)
    end
  end
end

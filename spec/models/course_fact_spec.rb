require 'spec_helper'

describe CourseFact do
  @methods = CourseFact.new.decorate.fact_kinds

  @methods.each do |method|
    it "retrieves a set of #{method} in order of position" do
      @course_factb = create :course_fact, kind: method, position: 2
      @course_facta = create :course_fact, kind: method, position: 1
      found = CourseFact.send(method.to_sym)
      expect(found).to eq([@course_facta, @course_factb])
    end
  end
end

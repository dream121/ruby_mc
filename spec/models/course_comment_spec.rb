require 'spec_helper'

describe CourseComment do

  let(:user_course) { create :user_course }
  let(:course) { user_course.course }
  let(:user) { user_course.user }
  let(:admin) { create :admin }
  let(:topic) { course.comments.create(comment: "Topic 1", user: admin) }
  let(:comment) { course.comments.create(comment: "Hello World", parent: topic, user: user, visible: true) }

  describe "for_course" do
    before do
      topic
      comment
    end

    it 'returns only top-level topics, not comments' do
      expect(CourseComment.for_course(course)).to eq([topic])
    end
  end
end

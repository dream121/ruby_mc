require 'spec_helper'

describe UsersWithoutCourseQuery do
  let!(:course1) { create :course }
  let!(:course2) { create :course }
  let!(:course3) { create :course }
  let!(:user1) { create :user }
  let!(:user2) { create :user }
  let!(:user3) { create :user }
  let!(:user4) { create :user }

  describe "find" do
    context "when some users have signed up for a course" do
      before do
        create :user_course, user: user1, course: course1
        create :user_course, user: user2, course: course2
        create :user_course, user: user1, course: course2
      end

      it 'finds only the users who have not signed up for course 1' do
        found = UsersWithoutCourseQuery.new.find(course1)
        expect(found.to_a.sort).to eq([user2, user3, user4].sort)
      end

      # it 'finds only the users who have not signed up for course 2' do
      #   found = UsersWithoutCourseQuery.new.find(course2)
      #   expect(found.to_a.sort).to eq([user1, user4].sort)
      # end

      # it 'finds only the users who have not signed up for course 3' do
      #   found = UsersWithoutCourseQuery.new.find(course3)
      #   expect(found.to_a.sort).to eq([user1, user2, user3, user4].sort)
      # end
    end
  end
end

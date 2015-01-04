require 'spec_helper'

describe CourseDecorator do
  describe '#up_next' do
    let (:user) { create :user }
    let (:course) { create :course }

    context 'when there are no completed lessons' do
      before do
        chapters = [4,5,1,7,8].map { |n| create :chapter, course: course, number: n }
        create :user_course, user: user, course: course
      end

      it 'returns the chapter with the lowest number' do
        expect(course.decorate.up_next(user).number).to eq 1
      end
    end

    context 'when there are completed lessons' do
      before do
        chapters = [5,1,4,8,7,9].map { |n| create :chapter, course: course, number: n }
        create :user_course, user: user, course: course, completed_chapters: chapters.slice(0..1)
      end

      it 'returns the chapter after the last completed one' do
        expect(course.decorate.up_next(user).number).to eq 7
      end
    end
  end
end

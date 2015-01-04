class UserCourse < ActiveRecord::Base
  belongs_to :user
  belongs_to :course, inverse_of: :user_courses
  belongs_to :order

  def update_progress(attrs)
    progress_will_change!
    self.progress ||= {}
    self.progress[attrs.delete(:chapter_id)] = attrs
    save
  end

  def comments
    course.comments
  end

  def instructor
    course.decorate.instructor
  end
end

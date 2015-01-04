class ChapterPolicy < CoursePolicy

  def index?
    false
  end

  def show?
    CoursePolicy.new(user, record.course).show?
  end

  def watch?
    if record.is_bonus == false
      admin? || enrolled?
    else
      record.is_unlocked?(completed_chapters_count) == true
    end
  end

  def move?
    admin?
  end

  def lock?
    admin?
  end

  def move?
    admin?
  end

  def lock?
    admin?
  end

  private

  def enrolled?
    user && user.courses.include?(record.course)
  end

  def completed_chapters_count
    user_course = user.user_courses.where(course_id: record.course_id).first.decorate.chapters_completed.count
  end

end

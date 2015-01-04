class UsersWithoutCourseQuery

  def initialize(relation = User.all)
    @relation = relation
  end

  def find(course)
    @relation.where.not(id: UserCourse.select(:user_id).where(course_id: course.id))
  end

  def find_each(&block)
    find.find_each(&block)
  end
end

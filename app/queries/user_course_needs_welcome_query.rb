class UserCourseNeedsWelcomeQuery
  WAIT_TIME = 4.hours

  def initialize(relation = UserCourse.all)
    @relation = relation
  end

  def find
    @relation.
      where("welcomed IS NOT TRUE").
      where("created_at <= ?", Time.now - WAIT_TIME)
  end

  def find_each(&block)
    find.find_each(&block)
  end
end

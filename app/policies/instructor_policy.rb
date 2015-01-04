class InstructorPolicy < CoursePolicy
  def index?
    admin?
  end

  def show?
    admin?
  end
end

class ImagePolicy < CoursePolicy
  def show?
    admin?
  end

  def index?
    admin?
  end
end

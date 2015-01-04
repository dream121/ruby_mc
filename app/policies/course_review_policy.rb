class CourseReviewPolicy < CoursePolicy

  def index?
    admin?
  end

  def new?
    admin? || enrolled?
  end

  def show?
    true
  end

  def create?
    admin? || (enrolled? && !reviewed?)
  end

  def update?
    admin? || record.user == user
  end

  def destroy?
    admin?
  end

  def edit?
    admin?
  end

  def moderate?
    admin?
  end

  private

  def enrolled?
    user && user.courses.include?(record.course)
  end

  def reviewed?
    record.course.reviews.where(user_id: user.id).count > 0
  end
end

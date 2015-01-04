class CourseCommentPolicy < CoursePolicy

  # create a new topic
  def new?
    admin?
  end

  def show?
    admin? || enrolled?
  end

  # create a new topic or comment
  def create?
    admin? || (enrolled? && record.parent && user.permissions['comments'])
  end

  # TODO: allow users to edit their own comments
  def update?
    admin? || (enrolled? && record.parent)
  end

  def moderate?
    admin?
  end

  def destroy?
    admin?
  end

  def vote?
    admin? || enrolled?
  end

  # TODO: allow users to edit their own comments
  def edit?
    admin?
  end

  private

  def enrolled?
    user && user.courses.include?(record.course)
  end


end

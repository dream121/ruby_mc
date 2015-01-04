class UserCoursePolicy < ApplicationPolicy
  def edit?
    admin?
  end

  def update?
    admin?
  end

  def index?
    admin?
  end

  def prospects?
    admin?
  end

  def api_update?
    admin? || user.user_courses.include?(record)
  end
end

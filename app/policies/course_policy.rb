class CoursePolicy < ApplicationPolicy

  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end
  end

  def index?
    true
  end

  def show?
    admin? || record.start_date <= Time.now
  end

  def new?
    admin?
  end

  def create?
    admin?
  end

  def edit?
    admin?
  end

  def update?
    admin?
  end

  def destroy?
    admin?
  end

  # enrolled

  def show_enrolled?
    admin? || enrolled?
  end

  def new_message?
    show_enrolled?
  end

  def create_message?
    show_enrolled?
  end

  def create_review?
    !reviewed?
  end

  private

  def enrolled?
    user && user.courses.include?(record)
  end

  def reviewed?
    record.reviews.where(user_id: user.id).count > 0
  end
end

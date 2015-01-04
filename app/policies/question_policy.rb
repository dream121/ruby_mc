class QuestionPolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      if user.admin?
        scope.all
      end
    end
  end

  def index
    true
  end

  def edit?
    admin?
  end

  def update?
    admin?
  end

  def admin_index?
    admin?
  end

  def destroy?
    admin?
  end

  def answer?
    admin?
  end

end

class ExperimentValuePolicy < ApplicationPolicy

  class Scope < Struct.new(:user, :scope)
    def resolve
      scope.for_user(user)
    end
  end

  def index?
    admin?
  end

  def show?
    admin?
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
end

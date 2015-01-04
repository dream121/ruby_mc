class OrderPolicy < ApplicationPolicy
  def index?
    admin?
  end

  def show?
    admin?
  end

  def new?
    true
  end

  def create?
    true
  end

  def edit?
    false
  end

  def update?
    false
  end

  def destroy?
    admin?
  end
end

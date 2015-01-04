class UserPolicy < ApplicationPolicy

  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end
  end

  def index?
    admin?
  end

  def show?
    admin?
  end

  def new?
    false
  end

  def create?
    false
  end

  def update?
    admin?
  end

  def destroy?
    admin? || user == record
  end

  def show_account?
    user == record
  end

  def edit_account?
    user == record
  end

  def update_account?
    user == record
  end
end

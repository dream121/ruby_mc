class CartPolicy < ApplicationPolicy
  def index?
    admin?
  end

  def destroy?
    admin?
  end

  def show?
    admin? || owned?
  end

  def create?
    true
  end

  def api_show?
    admin? || owned?
  end

  def api_update?
    admin? || owned?
  end

  def update?
    admin? || owned?
  end

  private

  def owned?
    user.cart == record
  end
end

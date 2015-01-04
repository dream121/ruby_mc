class PaymentPolicy < ApplicationPolicy
  def edit?
    admin?
  end

  def refund?
    admin?
  end
end

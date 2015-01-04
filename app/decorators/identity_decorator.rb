class IdentityDecorator < Draper::Decorator
  delegate_all

  def link_to_sign_in
    if errors[:email].join('').match(/Facebook/)
      :facebook
    elsif errors[:email].join('').match(/has already been taken/)
      :email
    end
  end
end

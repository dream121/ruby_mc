class ProfileDecorator < Draper::Decorator
  delegate_all

  def belongs_to user
    object.user == user
  end

  # def display_name
  #   # return I18n.t('profile_defaults.display_name') if object.user.decorate.full_name.blank? && object.display_name.blank?
  #   # return user.full_name if object.display_name.blank?
  #   # object.display_name
  # end

  def tagline
    if object.tagline.blank?
      I18n.t('profile_defaults.tagline')
    else
      object.tagline
    end
  end

  def tagline?
    !object.tagline.blank?
  end

  def country
    if country? && city?
       ", " + object.country
    else
      object.country
    end
  end

  def city?
    !object.city.blank?
  end

  def country?
    !object.country.blank?
  end
end

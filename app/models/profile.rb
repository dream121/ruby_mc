class Profile < ActiveRecord::Base
  belongs_to :user

  def display_name
    return self[:display_name] unless self[:display_name].blank?
    return user.full_name unless user.full_name.blank?
    return I18n.t('profile_defaults.display_name')
  end

  def tagline
    return self[:tagline] unless self[:tagline].blank?
    return I18n.t('profile_defaults.tagline')
  end
end

class UserDecorator < Draper::Decorator
  include HashHelper
  include UsStates
  include Countries
  include UserSettings
  delegate_all

  def first_name
    if !object.first_name.blank?
      object.first_name
    elsif !object.email.blank?
      object.email.split(/@/).first.titleize
    else
      'Accomplice User'
    end
  end

  def user_name
    if !object.first_name.blank?
      "#{object.first_name} #{object.last_name}"
    elsif !full_name.blank?
      full_name
    elsif !email.blank?
      email.split(/@/).first.titleize
    else
      'Accomplice User'
    end
  end

  def avatar_url
    if facebook
      if facebook.info && facebook.info['image']
        image_url = facebook.info['image'].split("?")[0] << "?width=100&height=100"
      end
    else
      image_url = gravatar_url(email)
    end
    image_url
  end

  def account_pic
    h.content_tag :div, class: 'visual' do
      if profile_photo_url
        uploaded_pic << h.link_to('remove', '/account/remove_image', class: 'remove', method: :delete, confirm: "Are you sure?", remote: true)
      elsif facebook
        fb_profile_pic
      else
        gravatar_profile_pic
      end
    end
  end

  def profile_pic
    h.content_tag :div, class: 'photo' do
      if profile_photo_url
        uploaded_pic << h.link_to('<i class="iconn-pencil"></i>'.html_safe, nil, class: 'edit')
      elsif facebook
        fb_profile_pic
      else
        gravatar_profile_pic
      end
    end
  end

  def user_profile_img_url
    if profile_photo_url
      profile_photo_url
    elsif facebook
      facebook.info['image'].split("?")[0] << "?width=100&height=100"
    else
      gravatar_url(email)
    end
  end

  def fb_profile_pic
    if facebook
      h.image_tag(facebook.info['image'].split("?")[0] << "?width=100&height=100")
    end
  end

  def gravatar_profile_pic
    unless facebook
      h.image_tag(gravatar_url(email))
    end
  end

  def uploaded_pic
    if profile_photo_url
      h.image_tag(profile_photo_url)
    end
  end

  def instructor?(course)
    course.instructors.include?(self.instructor)
  end

  def privacy_settings_visibility
    find_by_key(privacy_settings, 'visibility') || privacy_enrolled_visibility
  end

  def email_settings_general_info_new_class_available
    find_by_key(email_settings, 'new_class_available')
  end

  def new_class_available_checkbox_state
    fbk = find_by_key(email_settings, 'new_class_available')
    fbk == email_never_option_value || fbk.nil? ? false : true
  end

  def email_settings_general_info_monthly_newsletter
    find_by_key(email_settings, 'monthly_newsletter')
  end

  def monthly_newsletter_checkbox_state
    fbk = find_by_key(email_settings, 'monthly_newsletter')
    fbk == email_never_option_value || fbk.nil? ? false : true
  end

  def email_settings_email
    find_by_key(object.email_settings, 'email', email)
  end

  def email_settings_enrolled_classes_answered_question
    find_by_key(email_settings, 'answered_question')
  end

  def email_settings_enrolled_classes_answered_question_checkbox_state
    fbk = find_by_key(email_settings, 'answered_question', email_never_option_value)
    fbk == email_never_option_value || fbk.nil? ? false : true
  end

  def email_settings_enrolled_classes_reply_at_me
    find_by_key(email_settings, 'reply_at_me')
  end

  def reply_at_me_checkbox_state
    fbk = find_by_key(email_settings, 'reply_at_me')
    fbk == email_never_option_value || fbk.nil? ? false : true
  end

  def reply_at_me_now_radio_state
    find_by_key(email_settings, 'reply_at_me') == email_now_option_value
  end

  def reply_at_me_daily_radio_state
    find_by_key(email_settings, 'reply_at_me') == email_daily_option_value
  end

  def address_line_one
    find_by_key(address, 'line_one')
  end

  def address_line_two
    find_by_key(address, 'line_two')
  end

  def address_city
    find_by_key(address, 'city')
  end

  def address_zip_code
    find_by_key(address, 'zip_code')
  end

  def address_state_id
    find_by_key(address, 'state_id')
  end

  def address_country_id
    find_by_key(address, 'country_id')
  end

  private

  def gravatar_url(email)
    hash = Digest::MD5.hexdigest(email.downcase)
    "http://www.gravatar.com/avatar/#{hash}?s=50&d=identicon"
  end
end

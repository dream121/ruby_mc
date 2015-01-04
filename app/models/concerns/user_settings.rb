require 'active_support/concern'
module UserSettings
  extend ActiveSupport::Concern

  EMAIL_FREQUENCY = {
    'Never'         => 'never',
    'Now'           => 'now',
    'Once Daily'    => 'daily',
    'Once Monthly'  => 'monthly'
  }

  PROFILE_VISIBILITY = {
    'Enrolled users'  => 'enrolled_users',
    'Everyone'        => 'everyone',
    'Invisible'       => 'invisible'
  }

  included do
    # include class methods and dependencies here
  end

  def profile_visibilities
    profile_vis = PROFILE_VISIBILITY.deep_dup
    profile_vis.sort_by { |key, value| key }
  end

  def email_frequencies
    email_freqs = EMAIL_FREQUENCIES.deep_dup
    email_freqs.sort_by { |key, value|  key }
  end

  def email_now_option_value
    EMAIL_FREQUENCY['Now']
  end

  def email_daily_option_value
    EMAIL_FREQUENCY['Once Daily']
  end

  def email_monthly_option_value
    EMAIL_FREQUENCY['Once Monthly']
  end

  def email_never_option_value
    EMAIL_FREQUENCY['Never']
  end

  def privacy_full_visibility
    PROFILE_VISIBILITY['Everyone']
  end

  def privacy_enrolled_visibility
    PROFILE_VISIBILITY['Enrolled users']
  end

  def privacy_no_visibility
    PROFILE_VISIBILITY['Invisible']
  end
end

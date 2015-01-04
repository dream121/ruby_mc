# Be sure to restart your server when you modify this file.

session_key = Rails.env.production? ? '_masterclass_session' : "_masterclass_session_#{Rails.env}"
Masterclass::Application.config.session_store :cookie_store, key: session_key, domain: :all

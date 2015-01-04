# Acceptance builds on production's configuration.
require Rails.root.join('config/environments/production')

Masterclass::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb and config/production.rb.

 # Show full error reports and enable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = true

  config.action_mailer.default_url_options = { host: 'acceptance.goaccomplice.com' }

  # Enable these for Rails 4 asset problem
  config.cache_classes = true
  config.serve_static_assets = true
  config.assets.compile = true
  config.assets.digest = true
end

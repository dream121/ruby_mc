require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Masterclass
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Disable unwanted generators.
    config.generators do |generate|
      generate.stylesheets   false
      #generate.helper        false
      generate.routing_specs false
      #generate.view_specs    false
      generate.request_specs false
    end

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Pacific Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.paperclip_defaults = {
      ### Filesystem:
      # :url => "/system/:attachment/:id/:style/:filename"
      ### S3:
      path: "/:class/:id/:style/:filename",
      storage: :s3,
      url: ":s3_domain_url",
      s3_protocol: 'https',
      # s3_host_name: 's3-us-west-2.amazonaws.com',
      s3_credentials: {
        bucket: ENV['MASTERCLASS_AWS_BUCKET'],
        access_key_id: ENV['MASTERCLASS_AWS_ACCESS_KEY_ID'],
        secret_access_key: ENV['MASTERCLASS_AWS_SECRET_ACCESS_KEY']
      }
    }

    # config.use_ssl = false
    # config.ssl_port = 443
  end
end

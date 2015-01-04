OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer if Rails.env.test? or Rails.env.development?
  provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET'], :scope => 'email'
  provider :identity, on_failed_registration: lambda { |env|
    UserSessionsController.action(:sign_up).call(env)
  }
  # provider :google_oauth2, ENV['GOOGLE_KEY'], ENV['GOOGLE_SECRET']
end

# https://github.com/intridea/omniauth/wiki/FAQ#omniauthfailureendpoint-does-not-redirect-in-development-mode
OmniAuth.config.on_failure = Proc.new do |env|
  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
end

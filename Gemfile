source 'https://rubygems.org'
source 'https://rails-assets.org'

# Heroku uses the ruby version to configure your application's runtime.
ruby '2.0.0'

# server/db
gem 'unicorn'
gem 'rack-canonical-host'
gem 'rails', '~> 4.0.0'
gem 'pg'
gem 'newrelic_rpm'

# assets
gem 'slim-rails'
gem 'sass-rails'
gem 'bootstrap-sass', github: 'twbs/bootstrap-sass'
gem 'font-awesome-sass'
gem 'rails-assets-angular', '~> 1.2.27'
gem 'rails-assets-angular-resource', '~> 1.2.27'
gem 'rails-assets-angular-mocks', '~> 1.2.27'
gem 'angular-rails-templates'
gem 'jquery-rails'
gem 'coffee-rails'
gem 'uglifier'

# media
gem 'paperclip'
gem 'paperclip-ffmpeg'
gem 'aws-sdk'
gem 'zencoder'

# views
gem 'gon'
gem 'simple_form', '~> 3.0.0'
gem 'possessive'
gem 'valid_email'
gem 'draper'
gem 'jbuilder'
gem 'rabl'
gem 'eco'
gem 'oj'

# misc
gem 'acts_as_list'
gem 'friendly_id', '~> 5.0.0'
gem 'intercom-rails', '~> 0.2.21'
gem 'ltree_hierarchy',      # Tree hierarchy using PostreSQL's LTree extension.
  github: 'robworley/ltree_hierarchy'

# authorization/authentication
gem 'omniauth'
gem 'omniauth-facebook'
# ActiveModel::SecurePassword has a hard-coded dependency on bcrypt-ruby 3.0.0
gem 'bcrypt-ruby', '3.0.0'
gem 'omniauth-identity'
gem 'pundit', github: 'elabs/pundit'

# money
gem 'stripe', github: 'stripe/stripe-ruby'
gem 'money', '6.0.0.pre3'

# analytics
gem 'kmts', '~> 2.0.0'

# Heroku suggests that these gems aren't necessary, but they're required to compile less assets on deploy.
gem 'therubyracer', platforms: :ruby

group :test do
  gem 'webmock'
  gem 'vcr'
end

group :test, :development do
  gem 'rspec-rails'
  gem 'capybara'
  gem 'poltergeist'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
  gem 'fuubar'
  gem 'jasminerice', github: 'bradphelan/jasminerice' # Latest release still depends on haml.
  gem 'timecop'
  gem 'simplecov'
  gem 'quiet_assets'
  gem 'jazz_hands',
    github: 'nixme/jazz_hands',
    branch: 'bring-your-own-debugger'
  gem 'pry-byebug'
  gem 'figaro'
end

group :development do
  gem 'foreman'
  gem 'thin'
  gem 'launchy'
  gem 'better_errors'
  gem 'binding_of_caller'
  #gem 'rack-mini-profiler'
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-jasmine'
  gem 'guard-livereload'
  gem 'rb-fsevent'
  gem 'growl'
  gem "letter_opener"
end

group :production do
  gem 'rails_12factor'
end

# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.
Rails.application.config.filter_parameters += [:password, :stripeToken]
filters = Rails.application.config.filter_parameters
f = ActionDispatch::Http::ParameterFilter.new filters
f.filter :password => 'haha'

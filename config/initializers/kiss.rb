require 'kmts'

if Rails.env.test?
  options = {
    dryrun: true,
    use_cron: true,
    log_dir: File.join(Rails.root, 'log')
  }

  ENV['KISS_METRICS_KEY'] ||= 'test'
else
  options = {}
end

KMTS.init(ENV['KISS_METRICS_KEY'], options)

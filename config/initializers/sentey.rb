Sentry.init do |config|
  config.dsn = 'https://9a0ffdb271bef5286720aa81f18f703a@o4505832069857280.ingest.sentry.io/4505832078835712'
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]

  # Set traces_sample_rate to 1.0 to capture 100%
  # of transactions for performance monitoring.
  # We recommend adjusting this value in production.
  config.traces_sample_rate = 1.0
  # or
  config.traces_sampler = lambda do |context|
    true
  end
end
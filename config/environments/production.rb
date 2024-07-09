Rails.application.configure do
  # Ensure the master key is available
  config.require_master_key = true

  # Code is not reloaded between requests.
  config.cache_classes = true

  # Eager load code on boot.
  config.eager_load = true

  # Full error reports are disabled.
  config.consider_all_requests_local = false

  # Ensures that a master key has been made available in either ENV["RAILS_MASTER_KEY"]
  # or in config/master.key. This key is used to decrypt credentials (and other encrypted files).
  config.require_master_key = true

  # Disable serving static files from the `/public` folder by default since
  # Apache or NGINX already handles this.
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?

  # Compress JavaScripts and CSS.
  config.assets.js_compressor = Terser.new
  # config.assets.css_compressor = :sass

  # Do not fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = true

  # Store uploaded files on the Cloudinary.
  config.active_storage.service = :cloudinary

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  config.force_ssl = true

  # Use the lowest log level to ensure availability of diagnostic information when problems arise.
  config.log_level = :debug

  # Prepend all log lines with the following tags.
  config.log_tags = [:request_id]

  # Use Redis as the cache store in production.
  config.cache_store = :redis_cache_store, { url: ENV['REDIS_URL'] }

  # Use Redis for session storage.
  config.session_store :redis_store, {
    servers: [
      {
        url: ENV['REDIS_URL'],
        serializer: JSON,
        namespace: 'session'
      },
    ],
    expire_after: 90.minutes,
    key: "_#{Rails.application.class.module_parent_name.downcase}_session"
  }

  # Use Sidekiq for background jobs.
  config.active_job.queue_adapter = :sidekiq

  config.action_mailer.perform_caching = false

  config.i18n.fallbacks = true

  config.active_support.deprecation = :notify

  config.log_formatter = ::Logger::Formatter.new

  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger = ActiveSupport::TaggedLogging.new(logger)
  end

  config.active_record.dump_schema_after_migration = false

  config.action_mailer.default_url_options = { host: 'carsspot-1286c883ae12.herokuapp.com' }
  Rails.application.routes.default_url_options[:host] = 'carsspot-1286c883ae12.herokuapp.com'
end

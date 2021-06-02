Rails.application.configure do
  config.cache_classes = false
  config.eager_load = false
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false
  #Without
  config.public_file_server.enabled = true

  #With nginx
  # config.public_file_server.enabled = false

  config.assets.css_compressor = :sass

  config.assets.compile = true

  config.log_level = :debug

  config.log_tags = [ :request_id ]

  config.action_mailer.perform_caching = false

  config.i18n.fallbacks = true

  config.active_support.deprecation = :notify

  config.log_formatter = ::Logger::Formatter.new


  config.exceptions_app = self.routes

  config.active_record.dump_schema_after_migration = false
end
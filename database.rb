app_name = File.basename(destination_root).gsub('-', '_').downcase

remove_file 'config/database.yml'
create_file 'config/database.yml', <<~YAML
  default: &default
    adapter: postgresql
    encoding: unicode
    pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>

  sqlite: &sqlite
    adapter: sqlite3
    pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
    timeout: 5000

  development:
    primary:
      <<: *default
      database: #{app_name}_development
    queue:
      <<: *sqlite
      database: storage/development_queue.sqlite3
      migrations_paths: db/queue_migrate

  test:
    <<: *default
    database: #{app_name}_test

  production:
    primary: &primary_production
      <<: *default
      database: #{app_name}_production
      url: <%= Rails.application.credentials.DATABASE_URL %>
    cache:
      <<: *sqlite
      database: storage/#{app_name}_production_cache
      migrations_paths: db/cache_migrate
    queue:
      <<: *sqlite
      database: storage/#{app_name}_production_queue
      migrations_paths: db/queue_migrate
    cable:
      <<: *sqlite
      database: storage/#{app_name}_production_cable
      migrations_paths: db/cable_migrate
YAML

remove_file 'config/environments/development.rb'
create_file 'config/environments/development.rb', <<~RUBY
  require "active_support/core_ext/integer/time"

  Rails.application.configure do
    config.enable_reloading = true
    config.eager_load = false
    config.consider_all_requests_local = true
    config.server_timing = true

    if Rails.root.join("tmp/caching-dev.txt").exist?
      config.action_controller.perform_caching = true
      config.action_controller.enable_fragment_cache_logging = true
      config.public_file_server.headers = { "cache-control" => "public, max-age=\#{2.days.to_i}" }
    else
      config.action_controller.perform_caching = false
    end

    config.cache_store = :memory_store
    config.active_storage.service = :local
    config.action_mailer.raise_delivery_errors = false
    config.action_mailer.perform_caching = false
    config.action_mailer.default_url_options = { host: "localhost", port: 3000 }
    config.active_support.deprecation = :log
    config.active_record.migration_error = :page_load
    config.active_record.verbose_query_logs = true
    config.active_record.query_log_tags_enabled = true
    config.active_job.verbose_enqueue_logs = true
    config.action_view.annotate_rendered_view_with_filenames = true
    config.action_controller.raise_on_missing_callback_actions = true

    config.active_job.queue_adapter = :solid_queue
    config.solid_queue.connects_to = { database: { writing: :queue } }
  end
RUBY

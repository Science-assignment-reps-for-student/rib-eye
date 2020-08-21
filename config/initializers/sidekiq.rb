Sidekiq.configure_server do |config|
  config.redis = { url: "redis://#{ENV['SCARFS_PRODUCTION_REDIS']}:6379/rib-eye" }
end

Sidekiq.configure_client do |config|
  config.redis = { url: "redis://#{ENV['SCARFS_PRODUCTION_REDIS']}:6379/rib-eye" }
end

Sidekiq.default_worker_options = { retry: 1 }

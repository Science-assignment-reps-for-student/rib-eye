require 'connection_pool'
Redis::Objects.redis = ConnectionPool.new(size: 5, timeout: 3) { Redis.new(url: Rails.configuration.x.redis.object_redis_url, logger: Rails.logger) }

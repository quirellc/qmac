module Qmac
  module KeyProviders

    class Redis

      class Configurator

        def initialize
        end

        def redis_url
          @redis_url
        end

        def redis_url=(value)
          @redis_url = value
        end

      end

      class << self
        def configure
          raise 'Config has already been called' if @configurator

          # initialize our configurator object
          # and yield it back so that the client
          # of this library can configure it appropriately.
          @configurator = Configurator.new
          yield @configurator

          @connection ||= ConnectionPool.new() do
            ::Redis.new(url: @configurator.redis_url)
          end
        end

        def private_key_for(key)
          self._verify_configured
          @connection.with do |redis|
            redis.get(key)
          end
        end

        protected

        def _verify_configured
          raise 'No configuration provided' unless @configurator
        end

      end

    end

  end
end

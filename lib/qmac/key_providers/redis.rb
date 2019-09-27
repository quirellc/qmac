module Qmac
  module KeyProviders

    class Redis

      class Configurator

        attr_reader :expiration_interval, :redis_url

        def initialize
          # by default the keys will expire in 30 minutes
          self.expiration_interval = 1800
        end

        def expiration_interval=(value)
          @expiration_interval = value
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

          @connection ||= ::ConnectionPool.new() do
            ::Redis.new(url: @configurator.redis_url)
          end
        end

        # supported options
        # create: true (optionally create the private key if it doesn't already exist)
        def private_key_for(key_space, options = {})
          self._verify_configured
          @connection.with do |redis|
            if options.fetch(:create, false)
              while true
                result = self._update_private_key_safe(redis, key_space)
                break result unless result.nil?
              end
            else
              redis.get(key_space)
            end
          end
        end

        protected

        def _update_private_key_safe(redis, key_space)
          redis.watch(key_space) do
            result = redis.get(key_space)
            if result.nil?
              key = SecureRandom.hex(16)
              result = redis.multi do |multi|
                redis.set(key_space, key, ex: @configurator.expiration_interval)
              end
              result.nil? ? nil : key
            else
              redis.unwatch
              result
            end
          end
        end

        def _verify_configured
          raise 'No configuration provided' unless @configurator
        end

      end

    end

  end
end

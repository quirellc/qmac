module Qmac

  class Verifier

    class << self

      def valid?(hmac, components, key_space, key_provider)
        key = key_provider.private_key_for(key_space)
        raise 'Invalid key space/provider' unless key

        digest = OpenSSL::Digest::SHA256.new
        data = components.join('')
        computed_hmac = OpenSSL::HMAC.digest(digest, key, data)
        hmac == computed_hmac
      end

      def verify!(hmac, components, key_space, key_provider)
        raise 'hmac does not verify' unless self.valid?(hmac, components, key_space, key_provider)
      end

    end

  end

end

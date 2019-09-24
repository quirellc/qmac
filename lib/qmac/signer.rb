module Qmac

  class Signer

    class << self

      def sign(components, key_space, key_provider)

        key = key_provider.private_key_for(key_space)
        raise 'Invalid key space/provider' unless key

        digest = OpenSSL::Digest::SHA256.new
        data = components.join('')
        OpenSSL::HMAC.digest(digest, key, data)
      end

    end

  end

end

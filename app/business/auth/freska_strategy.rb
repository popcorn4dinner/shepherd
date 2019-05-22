  class FreskaStrateg < Warden::Strategies::Base

    def valid?
      api_token.present?
    end

    def authenticate!
      if user
        success!(authenticator.authenticate(api_token))
      else
        fail!('Invalid email or password')
      end
    end

    private

    def api_token
      env['HTTP_AUTHORIZATION'].to_s.remove('Bearer ')
    end

    def authenticator
      if Rails.settings.auth.enabled
        @public_key ||= File.read Rails.settings.auth.key_path
        @decoder ||= Freska::Auth::Decoder.new public_key, Freska::Auth::Core::ALGORITHM
        @authenticator ||= Freska::Auth::Authenticator.new(@decoder)
      else
        Freska::Auth::DummyAuthenticator.new('machine')
      end
    end

  end

module AuthenticationConverter
  class FacebookToIdentity
    def convert!(user)
      can_convert?(user)
      ActiveRecord::Base.transaction do
        destroy_facebook(user)
        identity = create_identity(user)
        create_authentication(identity, user)
      end
    end

    private

    class AuthenticationConverter::Error < StandardError; end;

    def can_convert?(user)
      if user.facebook.nil?
        raise AuthenticationConverter::Error.new('No facebook authentication exists')
      elsif user.identity
        raise AuthenticationConverter::Error.new('Email authentication exists')
      end
    end

    def destroy_facebook(user)
      user.facebook.destroy!
      user.reload
    end

    def create_identity(user)
      temp_password = SecureRandom.urlsafe_base64
      identity = Identity.new(
        email: user.email,
        name: user.name,
        password: temp_password,
        password_confirmation: temp_password
      )

      # need to skip validation due to existing user
      identity.save!(validate: false)
      identity
    end

    def create_authentication(identity, user)
      authenticator = UserAuthenticator.new
      auth = build_auth_hash(identity)
      authentication = authenticator.send(:create_authentication_with_auth, auth)
      authentication.user = user
      authentication.save!
    end

    def build_auth_hash(identity)
      {
        'provider' => 'identity',
        'uid' => identity.id.to_s,
        'info' => {'email' => identity.email, 'name' => identity.name},
        'credentials' => {}
      }
    end
  end
end

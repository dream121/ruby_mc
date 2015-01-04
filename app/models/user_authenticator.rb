class UserAuthenticator
  def user_from_auth(auth)
    authentication = find_authentication_with_auth(auth)
    unless authentication
      if Rails.env.production?
        raise UserAuthenticatorError.new('New signups not currently available. Please enter your email address on the home page for an invite.')
      else
        begin
          ActiveRecord::Base.transaction do
            authentication = create_authentication_with_auth(auth)
            create_user_with_authentication(authentication)
          end
        rescue ActiveRecord::RecordInvalid => e
          raise UserAuthenticatorError.new('A user with that email already exists')
        end
      end
    end
    authentication.user
  end

  def connect_user_with_auth(auth, user)
    taken = find_authentication_with_auth(auth)
    if taken
      raise FacebookAuthError.new('This facebook account has already been associated with a user.'\
                                        ' Please use a different facebook account or contact support'
      )
    else
      begin
        ActiveRecord::Base.transaction do
          authentication = create_authentication_with_auth(auth, user)
          update_user_settings(auth, user)
        end
      end
    end
    user
  end

  def update_user_settings(auth, user)
    user.full_name = user.full_name ? user.full_name : auth['info']['name']
    user.save!
  end


  def update_password(user, old_password, new_password_params)
    if identity_auth = user.identity
      if identity = identity_auth.identity
        if identity.authenticate(old_password)
          if identity.update(new_password_params)
            true
          else
            add_error(user, identity.errors.full_messages.to_sentence)
          end
        else
          add_error(user, "Old password does not match")
        end
      else
        add_error(user, "No existing password (did you sign up with Facebook?)")
      end
    else
      add_error(user, "No existing password (did you sign up with Facebook?)")
    end
  end

  def send_password_reset(email)
    identity = Identity.find_by(email: email.downcase)
    if identity
      set_token(identity)
      identity.save!
      AccountMailer.password_reset(identity).deliver
      return true
    else
      user = User.find_by(email: email.downcase)
      if user && user.facebook
        AccountMailer.password_reset_facebook(user).deliver
        return true
      else
        return false
      end
    end
  end

  def reset_password(identity, new_password_params)
    identity.update(new_password_params)
  end

  class UserAuthenticatorError < StandardError; end
  class FacebookAuthError < StandardError; end

  private

  def set_token(identity)
    begin
      identity.password_reset_token = SecureRandom.urlsafe_base64
    end while Identity.exists?(password_reset_token: identity.password_reset_token)
    identity.password_reset_sent_at = Time.zone.now
  end

  def add_error(user, message)
    user.errors.add(:base, message)
    false
  end

  def find_authentication_with_auth(auth)
    Authentication.find_by(provider: auth['provider'], uid: auth['uid'])
  end

  def create_authentication_with_auth(auth, user = nil)
    authentication = Authentication.create! do |authentication|
      authentication.provider = auth['provider']
      authentication.uid = auth['uid']
      authentication.info = auth['info']
      authentication.credentials = auth['credentials']
      if user
        authentication.user_id = user.id
      end
    end
    if auth['provider'] == 'identity'
      identity = Identity.find(auth['uid'])
      identity.authentication = authentication
      identity.save!
    end
    authentication
  end

  def create_user_with_authentication(authentication)
    user = authentication.create_user! do |user|
      user.email = authentication.info['email'].downcase
      user.full_name = authentication.info['name']
      user.create_profile!
    end
    if (authentication.provider == 'developer')
      user.update_permissions('admin' => true)
      user.save!
    end
    EventTracker.track(user.email, 'accounts.create')
    authentication.save!
  end
end

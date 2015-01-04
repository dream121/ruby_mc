require 'spec_helper'

describe UserAuthenticator do
  let(:authenticator) { UserAuthenticator.new }
  let(:identity) { create :identity }
  let(:email_user) { authenticator.user_from_auth(valid_omniauth_identity) }

  let(:valid_omniauth_identity) {
    {
      'provider' => 'identity',
      'uid' => identity.id.to_s,
      'info' => {'email' => identity.email, 'name' => identity.name},
      'credentials' => {'foo' => 'bar'}
    }
  }

  let(:valid_omniauth_facebook) {
    {
      'provider' => 'facebook',
      'uid' => '123',
      'info' => {'email' => identity.email, 'name' => identity.name},
      'credentials' => {'foo' => 'bar'}
    }
  }

  describe "#user_from_auth" do
    context "for an email user" do
      context "when no authentication exists" do
        before do
          email_user
        end

        it "creates an authentication and a user" do
          expect(email_user.email).to eq(identity.email)
          expect(email_user.name).to eq(identity.name)

          authentication = email_user.authentications.last
          expect(authentication.uid).to eq(valid_omniauth_identity['uid'])
          expect(authentication.provider).to eq('identity')
          expect(authentication.credentials).to eq({'foo' => 'bar'})

          expect(authentication.identity).to eq(identity)
        end
      end

      context "when an email authentication exists" do
        before do
          @existing_user = email_user
          @existing_authentication = @existing_user.authentications.last
        end

        it 'uses the existing authentication' do
          new_login = authenticator.user_from_auth(valid_omniauth_identity)
          expect(new_login).to eq(@existing_user)
          expect(new_login.authentications.last).to eq(@existing_authentication)
        end
      end

      context "when a facebook authentication exists" do
        before do
          @existing_user = authenticator.user_from_auth(valid_omniauth_facebook)
          @existing_authentication = @existing_user.authentications.last
        end

        it 'fails (todo: add another method for combining auths)' do
          expect { authenticator.user_from_auth(valid_omniauth_identity) }.to raise_error(UserAuthenticator::UserAuthenticatorError)
        end
      end

    end
  end

  describe '#update_password' do
    let(:update_password) { authenticator.update_password(email_user, old_password, new_password_params) }
    let(:old_password) { identity.password }
    let(:new_password_params) { { password: 'newpass', password_confirmation: 'newpass' } }

    context "when the old password matches" do
      context "and the new password params are valid" do
        it "returns true" do
          expect(update_password).to be_true
        end

        it "updates the password" do
          update_password
          email_user.identity.identity.reload
          expect(email_user.identity.identity.authenticate('newpass')).to be_true
        end

        it "adds no errors to user" do
          update_password
          expect(email_user.errors.any?).to be_false
        end
      end

      context "and the new password params are invalid" do
        let(:new_password_params) { { password: 'newpass', password_confirmation: 'mismatch' } }

        it "returns false" do
          expect(update_password).to be_false
        end

        it "does not update the password" do
          email_user.identity.identity.reload
          expect(email_user.identity.identity.authenticate('newpass')).to be_false
        end

        it "adds errors to user" do
          update_password
          expect(email_user.errors.any?).to be_true
        end
      end
    end

    context "when the old password doesn't match" do
      let(:old_password) { 'invalid' }

      it "returns false" do
        expect(update_password).to be_false
      end

      it "does not update the password" do
        update_password
        email_user.identity.identity.reload
        expect(email_user.identity.identity.authenticate('newpass')).to be_false
      end

      it "adds errors to user" do
        update_password
        expect(email_user.errors.any?).to be_true
      end
    end
  end

  describe '#send_password_reset' do
    context "when a user exists with the requested email address" do
      before do
        email_user
        authenticator.send_password_reset(identity.email)
      end

      it 'sets a password reset token for the relvant identity' do
        expect(identity.reload.password_reset_token).to_not be_nil
      end

      it 'generates an email for the relevant identity' do
        mail = ActionMailer::Base.deliveries.last
        expect(mail.to).to eq([identity.email])
        expect(mail.body).to match(%r(password_resets/#{identity.password_reset_token}))
      end
    end

    context "when no user exists with the requested email address" do
      it 'generates no emails' do
        expect { authenticator.send_password_reset('nobody@example.com') }.to_not change {ActionMailer::Base.deliveries.length}
      end
    end
  end
end

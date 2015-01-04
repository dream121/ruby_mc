require 'spec_helper'

describe AuthenticationConverter::FacebookToIdentity do

  let(:authenticator) { UserAuthenticator.new }
  let(:converter) { AuthenticationConverter::FacebookToIdentity.new }
  let(:user) { authenticator.user_from_auth(valid_omniauth_facebook) }

  let(:valid_omniauth_facebook) {
    {
      'provider' => 'facebook',
      'uid' => '123',
      'info' => {'email' => 'test@example.com', 'name' => 'Tom Middleton'},
      'credentials' => {'foo' => 'bar'}
    }
  }

  context 'when a facebook authentication exists' do
    before do
      converter.convert!(user)
    end

    it 'creates an authentication and identity' do
      expect(user.authentications.count).to eq(1)
      auth = user.authentications.first
      expect(auth.provider).to eq('identity')
      expect(auth.uid).to eq(auth.identity.id.to_s)
      expect(auth.identity.email).to eq('test@example.com')
      expect(auth.identity.name).to eq('Tom Middleton')
    end
  end

  context 'when no facebook authentication exists' do
    let(:user) { create :user }

    it 'raises an error' do
      expect { converter.convert!(user) }.to raise_error(AuthenticationConverter::Error)
    end

  end
end

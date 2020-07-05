require 'rails_helper'

describe UserAuthenticator do
  describe '#perform' do
    let(:authenticator) { described_class.new('sample_code') }

    subject { authenticator.perform }

    context 'incorrect code' do
      let(:error) {
        double("Sawyer::Resource", error: "bad_verification_code")
      }

      before do
        allow_any_instance_of(Octokit::Client).to receive(:exchange_code_for_token).and_return(error)
      end

      xit 'raises an error' do
        expect( subject ).to raise_error(
          UserAuthenticator::AuthenticationError
        )
        expect(authenticator.user).to be_nil
      end
    end

    context 'correct code' do
      let(:user_data) do
        {
          login: 'drubio',
          url: 'http://example.com',
          avatar_url: 'http//example.com/avatar',
          name: 'Daniel Rubio'
        }
      end
      before do
        allow_any_instance_of(Octokit::Client).to receive(:exchange_code_for_token).and_return('validtoken')
        allow_any_instance_of(Octokit::Client).to receive(:user).and_return(user_data)
      end

      it 'saves user when it doesnt exist' do
        expect { subject }.to change { User.count }.by 1
      end

      it 'reuses registered user' do
        user = create(:user, user_data)
        expect { subject }.to change { User.count }.by 0
      end

      it 'creates and sets a users access token' do
        expect{ subject }.to change{ AccessToken.count }.by 1
        expect(authenticator.access_token).to be_present
      end
    end
  end
end

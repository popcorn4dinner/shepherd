require 'spec_helper'

describe Freska::Auth::DummyAuthenticator do
  subject { described_class.new('some-user-type') }

  describe '#authenticate(token)' do
    it 'returns a user' do
      expect(subject.authenticate('some-token')).to be_a(Freska::Auth::User)
    end

    it 'raises Enforcer::RuleViolationError error if the passed token is "invalid-token"' do
      expect do
        subject.authenticate('invalid-token')
      end.to raise_error(Freska::Auth::InvalidTokenError)
    end
  end
end

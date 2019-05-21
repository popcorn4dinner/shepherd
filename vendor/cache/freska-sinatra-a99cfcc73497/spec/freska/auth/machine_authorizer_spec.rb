require 'spec_helper'

RSpec.describe Freska::Auth::MachineAuthorizer do

  let(:issuer) { double() }
  let(:cache) { double() }
  let(:decoder) { double() }

  let(:authorizer) { Freska::Auth::MachineAuthorizer.new 'app_name', cache, issuer, decoder }

  before do
    allow(issuer).to receive(:issue_with).and_return('token')
    allow(decoder).to receive(:decode).and_return({})
  end

  it 'should create and store a new token when not cached' do
    expect(cache).to receive(:cached?).and_return(false)
    expect(issuer).to receive(:issue_with).and_return('token')
    expect(cache).to receive(:save)

    expect(authorizer.token).to eq 'token'
  end

  it 'should use stored token when cached' do
    expect(cache).to receive(:cached?).and_return(true)
    expect(cache).to receive(:get).and_return('token')

    expect(authorizer.token).to eq 'token'
  end

  it 'should create and store a new token when invalid' do
    expect(cache).to receive(:cached?).and_return(true)
    expect(cache).to receive(:get).and_return('token')
    expect(cache).to receive(:save)
    expect(decoder).to receive(:decode).and_raise(Freska::Auth::ExpiredTokenError)


    expect(authorizer.token).to eq 'token'
  end

end

require 'spec_helper'

RSpec.describe Freska::Rest::Client do

  let(:adapter) { double(Freska::Rest::Adapters::Faraday) }
  let(:client) { Freska::Rest::Client.new('https://www.google.de', {}).tap { |c| c.adapter = adapter } }
  let(:authorizer) { double() }

  it 'should add authorization headers automatically if auto_auth is configured' do
    client.authorizer = authorizer

    expect(authorizer).to receive(:token).and_return('valid_token')
    expect(adapter).to receive(:call).with(:get, '/test', body: {}, headers:{'AUTHORIZATION' => 'Bearer valid_token'})

    client.get('/test')
  end

  it 'should not add authorization headers automatically nothing configured' do
    expect(adapter).to receive(:call).with(:get, '/test', body: {}, headers:{})

    client.get('/test')
  end

end

require_relative '../../spec_helper'

RSpec.describe Freska::Cache::Factory do

  it 'should create an decoder for sidecar instance' do
    config = {
      cache: {
        location: 'sidecar'
      }
    }.to_dot

    result = Freska::Cache::Factory.create(config)

    expect(result).to be_a(Memcached)
  end


  it 'should create an decoder with custom host' do
    config = {
      cache: {
        location: 'some_other_host'
      }
    }.to_dot

    result = Freska::Cache::Factory.create(config)

    expect(result).to be_a(Memcached)
  end

  it 'should create an decoder with custom port' do
    config = {
      cache: {
        location: 'some_other_host',
        port: '123'
      }
    }.to_dot

    result = Freska::Cache::Factory.create(config)

    expect(result).to be_a(Memcached)
  end

  it 'should create an decoder for sidecar instance' do
    config = {
      cache: {}
    }.to_dot

    expect {Freska::Cache::Factory.create(config)}.to raise_error(Freska::ConfigurationError)
  end

  it 'should create an decoder for sidecar instance' do
    config = {

    }.to_dot

    expect {Freska::Cache::Factory.create(config)}.to raise_error(Freska::ConfigurationError)
  end

end

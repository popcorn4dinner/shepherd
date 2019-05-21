require_relative '../../spec_helper'

RSpec.describe Freska::Firestore::Factory do

  skip 'should create an decoder for sidecar instance' do
    config = {
      firestore: {
        project: 'some_gcloud_project'
      }
    }.to_dot

    result = Freska::Firestore::Factory.create(config)

    expect(result).to be_a(Google::Cloud::Firestore::Client)
  end

  skip 'should create an decoder for sidecar instance' do
    config = {

    }.to_dot


    expect { Freska::Firestore::Factory.create(config) }.to raise_error(Freska::ConfigurationError)
  end

  skip 'should create an decoder for sidecar instance' do
    config = {
      firestore: {}
    }.to_dot

    expect { Freska::Firestore::Factory.create(config) }.to raise_error(Freska::ConfigurationError)
  end

end

# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Freska::Rest::Adapters::Faraday do
  subject { described_class.new('www.example.com') }

  describe '#call' do
    it 'calls the corresponding method on the Faraday connection object' do
      faraday_connection = double(Faraday::Connection)
      expect(Faraday).to receive(:new).and_return(faraday_connection)
      expect(faraday_connection)
        .to receive(:send).with(:put, anything, anything, anything)
              .and_return(double(headers: {}, body: '', status: 200))

      subject.call(:put, '/path')
    end
  end
end

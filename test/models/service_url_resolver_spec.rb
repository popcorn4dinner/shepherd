require 'rspec'

before(:all) do
  @consul_client = Diplomat::Service
  consul_service = OpenStruct.new(:Address => '1.2.3.4', :ServicePort => '12345')

  allow(@consul_client).to receive('some-service').and_return(consul_service)
end

describe 'resolve should process' do

  it 'an address prefixed with consul: and a path' do
    url = ServiceUrlResolver.resolve('consul:some-service/ping')

    expect(url).to be('1.2.3.4:12345/ping')
  end

  it 'an address prefixed with consul: and no path' do
    url = ServiceUrlResolver.resolve('consul:some-service')

    expect(url).to be('1.2.3.4:12345')
  end

  it 'return any address that\'s not resolvable' do
    url = ServiceUrlResolver.resolve('some-service:12345')

    expect(url).to be('some-service:12345')
  end

end
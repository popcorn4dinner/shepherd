class ServiceUrlResolver
  require 'uri'
  require 'diplomat'

  @@protocol = 'http://'

  def initialize(consul_client = Diplomat::Service)
    @consul_client = consul_client
  end

  def resolve(url)
    has_to_be_discovered?(url) ? discover(url) : url
  end

  def resolve_all(url)
    has_to_be_discovered?(url) ? discover_all(url) : [url]
  end

  private

  def discover(url)
    base_url = service_url_for consul_client.get service_reference_for url

    "#{@@protocol}#{base_url}/#{path_for(url)}"
  end

  def discover_all(url)
    consul_client.get(service_reference_for(url)).map{|service| "#{@@protocol}#{service_url_for(service)}/#{path_for(url)}"}
  end

  def has_to_be_discovered?(url)
    url.start_with?('consul:')
  end

  def service_reference_for(url)
    url.split('/').first.split(':').last
  end

  def service_url_for(consul_service)
    "#{consul_service.Address}:#{consul_service.ServicePort}"
  end

  def path_for(url)
    url.split('/')[1..-1].join('/')
  end

  def consul_client
    @consul_client
  end
end
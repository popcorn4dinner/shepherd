Diplomat.configure do |config|
  # Set up a custom Consul URL
  config.url = "#{Settings.service_discovery.consul_url}:#{Settings.service_discovery.consul_port}"
  # Set up a custom Faraday Middleware
  # config.middleware = MyCustomMiddleware
  # Connect into consul with custom access token (ACL)
  # config.acl_token =  "xxxxxxxx-yyyy-zzzz-1111-222222222222"
  # Set extra Faraday configuration options
  # config.options = {ssl: { version: :TLSv1_2 }}
end

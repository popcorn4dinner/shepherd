# -*- encoding: utf-8 -*-
# stub: freska 0.7.1 ruby lib

Gem::Specification.new do |s|
  s.name = "freska".freeze
  s.version = "0.7.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Bastian Schnieders".freeze]
  s.date = "2018-12-12"
  s.description = "Building onion style applications without tears".freeze
  s.email = "bastian.schnieders@freska.fi".freeze
  s.files = ["lib/enforcer/rule.rb".freeze, "lib/enforcer/rule_collection.rb".freeze, "lib/enforcer/rule_violation_error.rb".freeze, "lib/enforcer/rules/birthday_believable.rb".freeze, "lib/enforcer/rules/country_format.rb".freeze, "lib/enforcer/rules/email_format.rb".freeze, "lib/enforcer/rules/locale_format.rb".freeze, "lib/enforcer/rules/presence.rb".freeze, "lib/enforcer/validator.rb".freeze, "lib/freska.rb".freeze, "lib/freska/api_controller.rb".freeze, "lib/freska/auth/authenticator.rb".freeze, "lib/freska/auth/authorization_error.rb".freeze, "lib/freska/auth/claims_validator.rb".freeze, "lib/freska/auth/configurations/customers.rb".freeze, "lib/freska/auth/configurations/machines.rb".freeze, "lib/freska/auth/core.rb".freeze, "lib/freska/auth/decoder.rb".freeze, "lib/freska/auth/dummy_authenticator.rb".freeze, "lib/freska/auth/expired_token_error.rb".freeze, "lib/freska/auth/factory.rb".freeze, "lib/freska/auth/interceptor.rb".freeze, "lib/freska/auth/invalid_token_error.rb".freeze, "lib/freska/auth/machine_authorizer.rb".freeze, "lib/freska/auth/remote_issuer.rb".freeze, "lib/freska/auth/rules/audience_presence.rb".freeze, "lib/freska/auth/rules/expiration.rb".freeze, "lib/freska/auth/rules/issuer_correct.rb".freeze, "lib/freska/auth/rules/limited_renewals.rb".freeze, "lib/freska/auth/rules/not_blacklisted.rb".freeze, "lib/freska/auth/rules/not_usable_before.rb".freeze, "lib/freska/auth/rules/subject_presence.rb".freeze, "lib/freska/auth/user.rb".freeze, "lib/freska/cache/factory.rb".freeze, "lib/freska/configuration_error.rb".freeze, "lib/freska/firestore/factory.rb".freeze, "lib/freska/health_controller.rb".freeze, "lib/freska/kafka/encoders/factory.rb".freeze, "lib/freska/kafka/encoders/json.rb".freeze, "lib/freska/kafka/producer.rb".freeze, "lib/freska/kafka/producer_factory.rb".freeze, "lib/freska/logger_factory.rb".freeze, "lib/freska/rest/adapters/excon.rb".freeze, "lib/freska/rest/adapters/faraday.rb".freeze, "lib/freska/rest/adapters/internet.rb".freeze, "lib/freska/rest/client.rb".freeze, "lib/freska/rest/client_factory.rb".freeze, "lib/freska/rest/response.rb".freeze, "lib/freska/runtime_error.rb".freeze, "lib/freska/sql_connection_factory.rb".freeze, "lib/freska/version.rb".freeze, "lib/onion/agreement.rb".freeze, "lib/onion/command_error.rb".freeze, "lib/onion/command_executer.rb".freeze, "lib/onion/command_handler.rb".freeze]
  s.homepage = "https://github.com/freska-fi/freska-sinatra.git".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.6.13".freeze
  s.summary = "Utilities to ease building onion style applications with ruby and sinatra".freeze

  s.installed_by_version = "2.6.13" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>.freeze, ["~> 5.0"])
      s.add_runtime_dependency(%q<async-http>.freeze, ["~> 0.37"])
      s.add_runtime_dependency(%q<async>.freeze, ["~> 1.13"])
      s.add_runtime_dependency(%q<excon>.freeze, ["~> 0.62"])
      s.add_runtime_dependency(%q<faraday>.freeze, ["~> 0.15"])
      s.add_runtime_dependency(%q<hash_dot>.freeze, ["~> 2.4"])
      s.add_runtime_dependency(%q<jwt>.freeze, ["~> 2.1"])
      s.add_runtime_dependency(%q<lightly>.freeze, ["~> 0.3.2"])
      s.add_runtime_dependency(%q<require_all>.freeze, ["~> 2.0"])
      s.add_runtime_dependency(%q<ruby-kafka>.freeze, ["~> 0.7.5"])
      s.add_runtime_dependency(%q<sequel>.freeze, ["~> 5.13"])
      s.add_runtime_dependency(%q<sinatra>.freeze, ["~> 2.0"])
      s.add_runtime_dependency(%q<sinatra-param>.freeze, ["~> 1.5"])
      s.add_runtime_dependency(%q<rack-contrib>.freeze, ["~> 2.1.0"])
      s.add_runtime_dependency(%q<newrelic_rpm>.freeze, ["~> 6.2.0"])
      s.add_development_dependency(%q<rspec>.freeze, [">= 0"])
      s.add_development_dependency(%q<memcached>.freeze, [">= 0"])
      s.add_development_dependency(%q<google-cloud-firestore>.freeze, [">= 0"])
    else
      s.add_dependency(%q<activesupport>.freeze, ["~> 5.0"])
      s.add_dependency(%q<async-http>.freeze, ["~> 0.37"])
      s.add_dependency(%q<async>.freeze, ["~> 1.13"])
      s.add_dependency(%q<excon>.freeze, ["~> 0.62"])
      s.add_dependency(%q<faraday>.freeze, ["~> 0.15"])
      s.add_dependency(%q<hash_dot>.freeze, ["~> 2.4"])
      s.add_dependency(%q<jwt>.freeze, ["~> 2.1"])
      s.add_dependency(%q<lightly>.freeze, ["~> 0.3.2"])
      s.add_dependency(%q<require_all>.freeze, ["~> 2.0"])
      s.add_dependency(%q<ruby-kafka>.freeze, ["~> 0.7.5"])
      s.add_dependency(%q<sequel>.freeze, ["~> 5.13"])
      s.add_dependency(%q<sinatra>.freeze, ["~> 2.0"])
      s.add_dependency(%q<sinatra-param>.freeze, ["~> 1.5"])
      s.add_dependency(%q<rack-contrib>.freeze, ["~> 2.1.0"])
      s.add_dependency(%q<newrelic_rpm>.freeze, ["~> 6.2.0"])
      s.add_dependency(%q<rspec>.freeze, [">= 0"])
      s.add_dependency(%q<memcached>.freeze, [">= 0"])
      s.add_dependency(%q<google-cloud-firestore>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<activesupport>.freeze, ["~> 5.0"])
    s.add_dependency(%q<async-http>.freeze, ["~> 0.37"])
    s.add_dependency(%q<async>.freeze, ["~> 1.13"])
    s.add_dependency(%q<excon>.freeze, ["~> 0.62"])
    s.add_dependency(%q<faraday>.freeze, ["~> 0.15"])
    s.add_dependency(%q<hash_dot>.freeze, ["~> 2.4"])
    s.add_dependency(%q<jwt>.freeze, ["~> 2.1"])
    s.add_dependency(%q<lightly>.freeze, ["~> 0.3.2"])
    s.add_dependency(%q<require_all>.freeze, ["~> 2.0"])
    s.add_dependency(%q<ruby-kafka>.freeze, ["~> 0.7.5"])
    s.add_dependency(%q<sequel>.freeze, ["~> 5.13"])
    s.add_dependency(%q<sinatra>.freeze, ["~> 2.0"])
    s.add_dependency(%q<sinatra-param>.freeze, ["~> 1.5"])
    s.add_dependency(%q<rack-contrib>.freeze, ["~> 2.1.0"])
    s.add_dependency(%q<newrelic_rpm>.freeze, ["~> 6.2.0"])
    s.add_dependency(%q<rspec>.freeze, [">= 0"])
    s.add_dependency(%q<memcached>.freeze, [">= 0"])
    s.add_dependency(%q<google-cloud-firestore>.freeze, [">= 0"])
  end
end

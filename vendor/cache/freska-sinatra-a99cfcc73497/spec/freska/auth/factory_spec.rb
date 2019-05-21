require_relative '../../spec_helper'

RSpec.describe Freska::Auth::Factory do

  it 'should create an decoder with valid settings' do
    config = {
      framework: {
        auth_key_path: 'secrets/public.pem'
      },
      communication: {
        issuer: {
          url: 'auth-tokens.customer-team'
        }
      }
    }.to_dot

    result = Freska::Auth::Factory.new(config).create_decoder

    expect(result).to be_a(Freska::Auth::Decoder)
  end

  it 'should not create an decoder with missing key path' do
    config = {
      framework: {
      },
      communication: {
        issuer: {
          url: 'auth-tokens.customer-team'
        }
      }
    }.to_dot

    expect { Freska::Auth::Factory.new(config).create_decoder }.to raise_error(Freska::ConfigurationError)
  end

  it 'should create a machine authorizer' do
    config = {
      app: {
        name: 'my service'
      },
      framework: {
        logger: {
          target: 'stdout',
          level: 'fatal'
        },
        auth_key_path: 'secrets/public.pem'
      },
      communication: {
        issuer: {
          url: 'auth-tokens.customer-team'
        }
      }
    }.with_indifferent_access.to_dot

    result = Freska::Auth::Factory.new(config).create_machine_authorizer

    expect(result).to be_a(Freska::Auth::MachineAuthorizer)
  end

  it 'should be able to create authenticator with correct config' do
    config = {
      framework: {
        logger: {
          target: 'stdout',
          level: 'fatal'
        },
        auth_key_path: 'secrets/public.pem'
      },
      communication: {
        issuer: {
          url: 'auth-tokens.customer-team'
        }
      }
    }.with_indifferent_access.to_dot

    result = Freska::Auth::Factory.new(config).create_authenticator

    expect(result).to be_a(Freska::Auth::Authenticator)
  end

  it 'should be able to create a dummy authenticator' do
    config = {
      framework: {
        logger: {
          target: 'stdout',
          level: 'fatal'
        },
        simulate_auth_with: :machine
      }
    }.with_indifferent_access.to_dot

    result = Freska::Auth::Factory.new(config).create_authenticator

    expect(result).to be_a(Freska::Auth::DummyAuthenticator)
    expect(result.authenticate('machine')).to be_a(Freska::Auth::User)
  end

  it 'should create an issuer' do
    config = {
      framework: {
        logger: {
          target: 'stdout',
          level: 'fatal'
        },
        auth_key_path: 'secrets/public.pem'
      },
      communication: {
        issuer: {
          url: 'auth-tokens.customer-team'
        }
      }
    }.with_indifferent_access.to_dot

    result = Freska::Auth::Factory.new(config).create_issuer

    expect(result).to be_a(Freska::Auth::RemoteIssuer)
  end



end

# Freska Sinatra
Build ruby services the fast way

## Api controller
Make your Controllers inherit from `Freska::ApiController` to enable 
- standardised error handling
- rails-like configuration with yaml files
- onion helpers
- ...

```ruby
module Infrastructure
  class V1Controller < ::Freska::ApiController


    get '/your/endpoint' do
      # your code goes here
    end
    
  ...  
```

## Onion Architecture
Build onion style applications without tears.  
This gem provides reusable abstractions and helpers to make it easy for you to design your application along the principles of [Onion Architecture](https://jeffreypalermo.com/2008/07/the-onion-architecture-part-1/).   

![onion architecture](https://github.com/popcorn4dinner/php-commands/blob/master/onion_schema.png)

## Installation
```
# add something here
```

## Usage

### Controller helper
execute commands in your controller:
```ruby
...

  include Onion::CommandExecuter
  helpers Sinatra::Param
    
  post '/customer/signin_with_password' do
       param :email, String, required: true
       param :password, String, required: true

       begin
       
       # executing the command
       result = execute Application::SignInWithPassword, with: params, uses: [jwt_secret, customer_repo, customer_blacklist]

       @customer = result[:customer]
       @auth_token = result[:auth_token]

       status 200
       jbuilder :customer

       rescue Domain::Customer::InvalidCredentialsError => error
         status 401
         error.to_json
       rescue Domain::Customer::BlacklistedError => error
         status 401
         error.to_json
       end
    end
    
...
```

### Application layer - CommandHandlers
This gem provides an implementation of *command handlers* for you to quickly get started with the *application layer* of your app:

Example:
```ruby
module Application
  class SignUpWithPassword < Onion::CommandHandler
    
    # exclude fields from being logged if needed
    log_blacking_for :first_name, :last_name, :password, :password_confirmation, :email, :birthday

    # dependencies are injected, every dependency located in the infrastructure layer 
    # must have a corresponding "agreement" in the domain layer
    def initialize(customer_repo, mailer, validator = nil)
      @customer_repo = customer_repo
      @mailer = mailer
      @validator = validator || Domain::Customer::Validator.new(customer_repo)
    end

    # the handle method controlles the command handlers flow. 
    # it's parameters implicitly determine the command being handled
    def handle(email:, last_name:, first_name:, birthday:, password:, password_confirmation:)
      verify_password_confirmation_for! password, password_confirmation
      verify_password_strength_for! password, first_name, last_name, email

      customer = Domain::Customer::Processor.create_customer_with(
        last_name: last_name,
        first_name: first_name,
        email: email,
        birthday: birthday,
        password: password
      )

      @validator.verify(customer, :sign_up_with_password)
      @customer_repo.create(customer)
      @mailer.send_email_confirmation_request(customer)

      customer
    end

    private

    ...

  end
end
```

### Agreements
Agreements are somewhat like interfaces. They enable you to define and document the interface of repositories, etc in your domain layer and have several implementations in the Infrastructure layer.
Agreement:
```ruby
module Domain
  module Customer
    class Repository

      include Onion::Agreement

      def create(customer)
        implement_this!
      end

      def update(customer)
        implement_this!
      end

      def find_by_id(id)
        implement_this!
      end

     ...
     
    end
  end
end

```

Implementation
```ruby
module Infrastructure::Repositories
 class InMemoryCustomerRepository < Domain::Customer::Repository

   def create(customer)
     customers[customer.id] = customer
   end

   def update(customer)
     customers[customer.id] = customer
   end

   def find_by_id(id)
     customers[id]
   end

   ...

   private

   def customers
     @customers ||= {}
   end

   def find_by(field, value)
     customers.values.find { |c| c.send(field).eql?(value) }
   end
 end
end

```
### Rest Clients
You can create rest clients based on your services configuration.
#### Configuration
```yaml
# config/development.yaml

...
app
  rest_communication:
    my_target:
      url: "www.gppgleapis.com"
      http_version: 1

```

#### Creating a rest client
Depending on the configured http version, the factory will return a `faraday` or a `net-http2` instance.
```ruby
module Infrastructure
  class V1Controller < Freska::ApiController

    get '/pizza' do
      factory = Freska::Rest::ClientFactory.new settings
      client = factory.client_for 'my_target'
      
      cheese = client.call(:get, '/cheese')
    end
```

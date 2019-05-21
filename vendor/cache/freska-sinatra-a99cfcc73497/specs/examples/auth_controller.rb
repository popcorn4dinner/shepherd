require 'jbuilder'

module Examples
  class AuthController < Freska::ApiController
    use Freska::Auth::Interceptor
    helpers Freska::Auth::CurrentUserHelper

    set :views, File.join(__dir__, 'views')

    get '/greeting' do
      "hello"
    end
  end
end

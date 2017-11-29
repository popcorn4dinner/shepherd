# Load DSL and set up stages
require 'capistrano/setup'

# Include default deployment tasks
require 'capistrano/deploy'

require 'capistrano/scm/git'
install_plugin Capistrano::SCM::Git


require 'capistrano/rbenv'
require 'capistrano/bundler'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'
require 'capistrano/nginx'

require 'capistrano/puma'
require 'capistrano/puma/nginx'
require 'capistrano/upload-config'
install_plugin Capistrano::Puma
install_plugin Capistrano::Puma::Nginx



# If you are using rbenv add these lines:
set :rbenv_type, :user
set :rbenv_ruby, '2.3.3'

# Load the SCM plugin appropriate to your project:
require 'capistrano/scm/git'
install_plugin Capistrano::SCM::Git

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }

set :stage, :dev
set :rails_env, :production
set :branch, "production"
set :pty, true
set :ssh_options, {
   keys: ["~/.ssh/shepherd.pem"],
   forward_agent: true,
   auth_methods: ["publickey"]
 }


server "10.249.156.54", user: "ubuntu", roles: %w{app web db}

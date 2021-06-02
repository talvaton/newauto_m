after 'deploy:published', 'data:database'
after 'deploy:published', 'data:clear'

set :stage, "production"
#set :rails_env, :production

set :bundle_path, 'bundle'
set :bundle_flags, '--quiet'
set :bundle_without, %w{test}.join(' ')

set :deploy_to, "/var/www/carso_new_production"

server "45.128.207.158", user: "carso_master", roles: %w{web app}, port: 22
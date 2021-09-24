#after 'deploy:published', 'data:database'
after 'deploy:published', 'data:clear'

set :stage, "production"
set :rails_env, :production

set :bundle_path, 'bundle'
set :bundle_flags, '--quiet'
set :bundle_without, %w{test}.join(' ')

set :deploy_to, "/var/www/autosalon_production"

server "188.120.229.83", user: "khan", roles: %w{web app}, port: 32221
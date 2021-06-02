# after 'deploy:published', 'sitemap:refresh'
after 'deploy:published', 'data:clear'

set :stage, "development"
set :rails_env, :development

set :bundle_path, 'bundle'
set :bundle_flags, '--quiet'
set :bundle_without, %w{test}.join(' ')

set :deploy_to, "/var/www/carso_new_staging"

server "45.128.207.158", user: "carso_master", roles: %w{web app}, port: 22

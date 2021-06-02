# after 'deploy:published', 'sitemap:refresh'
# after 'deploy:published', 'data:clear'

set :stage, "development"
set :rails_env, :development

set :bundle_path, 'bundle'
set :bundle_flags, '--quiet'
set :bundle_without, %w{test}.join(' ')

set :deploy_to, "/var/www/autosalon_staging"

server "62.109.5.245", user: "khan", roles: %w{web app}, port: 32221

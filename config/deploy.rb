#lock "~> 3.15.0"

set :application, "carso_sait_new"
set :repo_url, "git@bitbucket.org:andreevmap_work/carso_sait_new.git"

set :linked_files, %w{config/master.key config/database.yml}
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets','public/uploads','public/images','public/sitemaps','node_modules','bundle')

set :migration_role, :app

set :rbenv_type, :user
set :rbenv_ruby, "2.5.3"

set :rbenv_path, '/home/carso_master/.rbenv/'

set :puma_restart_command, 'bundle exec --keep-file-descriptors puma'

after :deploy, "puma:stop"
after :deploy, "puma:start"
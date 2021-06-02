require "capistrano/setup"
require "capistrano/deploy"
require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git

require 'capistrano/rails'
require "capistrano/rbenv"
require "capistrano/bundler"
require 'capistrano/yarn'
require "capistrano/rails/assets"
require "capistrano/rails/migrations"
require 'capistrano/sitemap_generator'

require 'capistrano/puma'
install_plugin Capistrano::Puma, load_hooks: false

Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }

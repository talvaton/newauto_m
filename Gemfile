source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.0'
# Use mysql as the database for Active Record
gem 'mysql2', '>= 0.4.4', '< 0.6.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
gem 'bootstrap', '~> 4.2.1'
# Use Uglifier as compressor for JavaScript assets
# gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
# gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
gem 'bcrypt'

# For Parsing
gem 'nokogiri'
gem 'htmlentities'
gem 'truncate_html'

# connecting to spaces
gem "fog-aws"

group :development do
  gem 'capistrano',         require: false
  gem 'capistrano-rbenv',     require: false
  gem 'capistrano-rails',   require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano3-puma',   require: false
  gem 'capistrano-yarn',   require: false
end


# Use ActiveStorage variant
gem 'carrierwave'
gem 'image_optim'
gem 'carrierwave-imageoptim'
gem 'mini_magick'

# Action caching
gem 'actionpack-action_caching'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'
# Breadcrumps
# gem "breadcrumbs_on_rails"
gem 'loaf'

# Работа с пагинацией
gem 'kaminari'


# Gem for colors
gem 'paleta'

# antispam
# gem 'invisible_captcha'

# Валидация
gem 'client_side_validations'

# Sitemap
gem 'sitemap_generator'

# gem 'tinymce-rails'
gem 'rails-i18n'

# jquery
gem 'jquery-rails'
gem 'remotipart'

# CRON
gem 'whenever', require: false

# Вычисляем по IP
gem 'maxminddb'

# lazyloading
gem "lazyload-rails"

# device detection
gem 'device_detector'

# Web service
# gem 'serviceworker-rails'

group :salon_dev,:test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]

  gem 'rspec-rails'
  gem "factory_bot_rails"
  gem 'rails-controller-testing'
  gem 'faker'
end

group :salon_dev do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'better_errors'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'colorize'

  gem 'rubycop'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'database_cleaner'

  # Easy installation and use of chromedriver to run system tests with Chrome
  # gem 'chromedriver-helper'
end
gem 'simplecov', require: false, group: :test

# Profiling

# For memory profiling
# gem 'memory_profiler'
# For call-stack profiling flamegraphs
# gem 'flamegraph'
# gem 'stackprof'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'rack-mini-profiler',require: false

gem 'mimemagic', '~> 0.3.3'


gem 'ed25519', '>= 1.2', '< 2.0'
gem 'bcrypt_pbkdf', '>= 1.0', '< 2.0'
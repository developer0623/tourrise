# frozen_string_literal: true

source 'https://rubygems.org'
# ruby '2.7.2'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'rack-cors', require: 'rack/cors'
gem 'rails', '~> 6.0.3.5'
gem 'draper', '~> 4.0.0'
gem 'mysql2', '~> 0.5.2'
gem 'puma', '~> 5.0' # Use Puma as the app server
gem 'sassc-rails'
gem 'uglifier', '>= 1.3.0' # Use Uglifier as compressor for JavaScript assets
gem 'mini_magick'
gem 'aws-sdk-s3', require: false
gem 'image_processing', '~> 1.2'
gem 'mjml-rails'
gem 'addressable'
gem 'view_component'

gem 'aasm'

gem 'bunny', '~> 2.17'

gem 'tolk', '~> 4.0', '>= 4.0.1' # Tolk is a web interface for doing i18n translations packaged as an engine for Rails applications.

gem 'bootsnap', require: false

gem 'country_select', '~> 5.0'

gem 'bcrypt', '~> 3.1.7' # Use ActiveModel has_secure_password
gem 'dry-validation'
gem 'interactor-rails', '~> 2.2' # Interactors are used to encapsulate your application's business logic. Each interactor represents one thing that your application does.

gem 'turbo-rails'

gem 'jbuilder' # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder

gem 'jsonapi-rails'
gem 'iso-639' # Language codes
gem 'money-rails' # Currency shiat

gem 'devise' # Authentication framework
gem 'devise_invitable', '~> 2.0.1' # Devise invite plugin

gem 'caxlsx'
gem 'caxlsx_rails'

gem 'easybill-api', '~> 0.7.5'
gem 'honeybadger', '~> 4.0'

gem 'delayed_job_active_record'

gem 'rails-i18n'
gem 'kaminari'
gem 'webpacker', '~> 5.0'

gem 'globalize', git: 'https://github.com/globalize/globalize' # Globalize builds on the I18n API in Ruby on Rails to add model translations to ActiveRecord models.
gem 'activemodel-serializers-xml'
gem 'paper_trail' # Track changes to your models
gem 'gretel' # Gretel is a Ruby on Rails plugin that makes it easy yet flexible to create breadcrumbs

gem 'simple_calendar', '~> 2.0' # Simple Calendar is designed render a calendar in views. Read more: https://github.com/excid3/simple_calendar

gem "chartkick" # Creates beautiful JavaScript charts with one line of Ruby
gem 'groupdate'

gem 'faker'
gem 'data_migrate' # Run data migrations alongside schema migrations.
gem "paranoia", "~> 2.4.2"

group :development, :test do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'byebug', platforms: %i[mri mingw x64_mingw] # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'capybara', '~> 3.0' # Adds support for Capybara system testing and selenium driver
  gem 'dotenv-rails'
  gem 'timecop'
  gem 'rspec-rails', '~> 5.0.0'
  gem 'rubocop', require: false
  gem 'rubocop-performance'
  gem 'rubocop-rspec'
  gem 'selenium-webdriver'
  gem 'pry', '~> 0.14.0'
end

group :test do
  gem 'factory_bot_rails', '~> 6.1.0'
  gem 'shoulda-matchers'
  gem 'rails-controller-testing'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.5'
  gem 'spring' # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0' # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby] # Windows does not include zoneinfo files, so bundle the tzinfo-data gem

gem 'easybill', path: 'easybill'

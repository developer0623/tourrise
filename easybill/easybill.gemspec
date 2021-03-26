# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "easybill/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "easybill"
  s.version     = Easybill::VERSION
  s.authors     = ["Patrick Schnetger"]
  s.email       = ["patrick.schnetger@gmail.com"]
  s.homepage    = "https://www.patrick-schnetger.com"
  s.summary     = "This engine is responsible for everything related to easybill"
  s.description = "Yep still easybill"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "bunny", "~> 2.17"
  s.add_dependency "devise"
  s.add_dependency "draper"
  s.add_dependency "dry-struct"
  s.add_dependency "easybill-api"
  s.add_dependency "interactor-rails"
  s.add_dependency "jsonapi-rails"
  s.add_dependency "money-rails"
  s.add_dependency "rails", "~> 6.0.3.5"

  s.add_development_dependency "byebug"
  s.add_development_dependency "capybara", "~> 2.13"
  s.add_development_dependency "database_cleaner-active_record"
  s.add_development_dependency "globalize"
  s.add_development_dependency "jsonapi-rspec"
  s.add_development_dependency "mysql2"
  s.add_development_dependency "rails-i18n"
  s.add_development_dependency "rspec"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "rubocop"
  s.add_development_dependency "rubocop-performance"
  s.add_development_dependency "rubocop-rspec"
  s.add_development_dependency "shoulda-matchers", "~> 3.1"
  s.add_development_dependency "timecop"
end

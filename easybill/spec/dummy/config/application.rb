# frozen_string_literal: true

require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'action_cable/engine'
require 'sprockets/railtie'

Bundler.require(*Rails.groups)
require 'easybill'

module Dummy
  class Application < Rails::Application
    config.i18n.default_locale = :de
    config.i18n.available_locales = %i[de-RAW de en fr]
    config.i18n.fallbacks = %i[de de-RAW]

    config.public_locales = config.i18n.available_locales.reject { |locale| locale == :'de-RAW' }

    config.load_defaults 6.0
    config.time_zone = 'Berlin'
    config.active_record.default_timezone = :local

    config.active_record.time_zone_aware_types = %i[datetime time]

    config.autoload_paths << Rails.root.join('app', 'serializers')
    config.generators.javascript_engine = :js

    config.action_controller.always_permitted_parameters = %w[format]
  end
end

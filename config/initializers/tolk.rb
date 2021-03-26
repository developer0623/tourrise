# encoding: utf-8

Tolk.config do |config|
  config.mapping['de-RAW'] = 'German (default)'

  config.primary_locale_name = 'de-RAW'

  config.ignore_keys = %w[
    activerecord.attributes.user
    date
    datetime
    devise
    errors
    faker
    helpers.submit
    number
    support.array
    time
  ]
end

# frozen_string_literal: true

require "dry-struct"
require "interactor"
require "easybill/api"
require "money-rails"
require "rails-i18n"
require "bunny"
require "jsonapi/rails"
require "draper"
require "devise"

require_relative "./easybill/amqp/client"
require_relative "./easybill/amqp/listener"

require "easybill/engine"

module Easybill
  # Your code goes here...
end

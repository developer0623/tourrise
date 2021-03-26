# frozen_string_literal: true

module Easybill
  class ProductConfiguration < ApplicationRecord
    translates :offer_template, :invoice_template, fallbacks_for_empty_translations: true
    include GlobalizeScope

    belongs_to :product

    def self.default_offer_template
      return "DE" if I18n.locale == :de

      "EN"
    end

    def self.default_invoice_template
      return "DE" if I18n.locale == :de

      "EN"
    end

    def self.default_advance_invoice_template
      default_invoice_template
    end

    def offer_template
      read_attribute(:offer_template) || self.class.default_offer_template
    end

    def invoice_template
      read_attribute(:invoice_template) || self.class.default_invoice_template
    end

    def advance_invoice_template
      invoice_template
    end
  end
end

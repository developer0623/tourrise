# frozen_string_literal: true

module Frontoffice
  class ResourceDecorator < Draper::Decorator
    delegate_all

    decorates_association :resource_skus, with: Frontoffice::ResourceSkuDecorator, scope: :available

    def label
      object.name
    end

    def list
      resource_skus
    end

    def display_featured_image
      h.featured_image(featured_image, alt: label)
    end

    # TODO: when pricing feature is going live for the frontoffice
    def start_price
      # I18n.t("start_price", price: object.price)
    end
  end
end

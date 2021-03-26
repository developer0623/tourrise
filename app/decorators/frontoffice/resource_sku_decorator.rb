# frozen_string_literal: true

module Frontoffice
  class ResourceSkuDecorator < ::ResourceSkuDecorator
    def featured_image
      return resource.featured_image if images.blank?

      images.first
    end

    def display_featured_image
      h.thumbnail(featured_image, alt: label)
    end
  end
end

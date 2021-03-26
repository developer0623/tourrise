# frozen_string_literal: true

module Frontoffice
  class AccommodationDecorator < ::Frontoffice::ResourceDecorator
    def uniq_key
      "accommodation-#{object.id}"
    end
  end
end

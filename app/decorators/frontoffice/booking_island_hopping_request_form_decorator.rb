# frozen_string_literal: true

module Frontoffice
  class BookingIslandHoppingRequestFormDecorator < BookingFormDecorator
    def island_hoppings
      object.island_hoppings.map do |package|
        Frontoffice::ResourceDecorator.decorate(package)
      end
    end

    def current_step_handle
      :island_hopping_request
    end
  end
end

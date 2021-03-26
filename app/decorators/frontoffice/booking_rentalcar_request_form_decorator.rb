# frozen_string_literal: true

module Frontoffice
  class BookingRentalcarRequestFormDecorator < BookingFormDecorator
    def rentalcars
      object.rentalcars.map do |rentalcar|
        Frontoffice::ResourceDecorator.decorate(rentalcar)
      end
    end

    def default_rentalcars_count
      0
    end

    def rentalcars_count
      object.booking.rentalcars_count || default_rentalcars_count
    end

    def max_rentalcars
      object.booking.people_count
    end

    def current_step_handle
      :rentalcar_request
    end
  end
end

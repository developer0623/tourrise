# frozen_string_literal: true

module Frontoffice
  class BookingRentalbikeRequestFormDecorator < BookingFormDecorator
    def current_step_handle
      :rentalbike_request
    end

    def default_rentalbikes_count
      0
    end

    def rentalbikes_count
      object.booking.rentalbikes_count || default_rentalbikes_count
    end

    def max_rentalbikes
      object.booking.people_count
    end
  end
end

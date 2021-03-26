# frozen_string_literal: true

module Frontoffice
  class BookingFlightRequestFormDecorator < BookingFormDecorator
    def destination_airport
      return unless object.product_sku.product_sku_booking_configuration.present?

      object.product_sku.product_sku_booking_configuration.default_destination_airport_code
    end

    def current_step_handle
      :flight_request
    end
  end
end

# frozen_string_literal: true

module Frontoffice
  class BookingSummaryFormDecorator < BookingFormDecorator
    delegate :booking_resource_skus, :customer, :wishyouwhat, to: :booking

    def current_step_handle
      :summary
    end

    def booking_with_transport?
      object.booking.booking_flight_requests.any? || object.booking.booking_rentalbike_requests.any? || object.booking.booking_rentalcar_requests.any?
    end

    def show_wishyouwhat_field?
      !object.product_sku.product_sku_booking_configuration&.wishyouwhat_on_first_step?
    end
  end
end

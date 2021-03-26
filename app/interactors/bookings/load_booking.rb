# frozen_string_literal: true

module Bookings
  class LoadBooking
    include Interactor

    delegate :booking_id, to: :context

    def call
      context.fail!(message: I18n.t("interactor_errors.empty", attribute: :booking_id)) unless booking_id.present?

      booking = Booking.find_by_id(booking_id)

      context.fail!(message: I18n.t("errors.not_found")) unless booking.present?

      context.booking = booking
    end
  end
end

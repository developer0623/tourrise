# frozen_string_literal: true

module Bookings
  class ChangeSecondaryState
    include Interactor

    delegate :booking, :secondary_state, to: :context

    def call
      new_secondary_state = secondary_state.presence || guess_secondary_state

      booking.update_attribute(:secondary_state, new_secondary_state)

      context.fail!(message: booking.errors.full_messages) unless booking.valid?
    end

    private

    def guess_secondary_state
      return nil unless booking.in_progress?

      secondary_state = if booking_service.invoice_available?
                          :invoice_sent
                        elsif booking_service.offer_available?
                          :offer_sent
                        else
                          :offer_missing
                        end
      secondary_state
    end

    def booking_service
      @booking_service ||= BookingService.new(booking)
    end
  end
end

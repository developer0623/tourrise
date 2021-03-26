# frozen_string_literal: true

module Bookings
  class PublishBookingClosedEvent
    include Interactor

    def call
      PublishEventJob.perform_later(Event::BOOKING_CLOSED, context.booking)
    end
  end
end

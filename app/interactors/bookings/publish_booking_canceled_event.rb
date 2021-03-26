# frozen_string_literal: true

module Bookings
  class PublishBookingCanceledEvent
    include Interactor

    def call
      PublishEventJob.perform_later(Event::BOOKING_CANCELED, context.booking)
    end
  end
end

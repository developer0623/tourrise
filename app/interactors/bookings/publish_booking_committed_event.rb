# frozen_string_literal: true

module Bookings
  class PublishBookingCommittedEvent
    include Interactor

    def call
      PublishEventJob.perform_later(Event::BOOKING_COMMITTED, context.booking)
    end
  end
end

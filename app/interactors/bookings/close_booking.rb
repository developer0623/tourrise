# frozen_string_literal: true

module Bookings
  class CloseBooking
    include Interactor::Organizer

    before do
      context.transition_method_name = :close
      context.secondary_state = nil
    end

    organize LoadBooking,
             ResetDueDate,
             ChangeBookingState,
             ChangeSecondaryState,
             UnblockBookingResourceSkus,
             PublishBookingClosedEvent
  end
end

# frozen_string_literal: true

module Bookings
  class CancelBooking
    include Interactor::Organizer

    before do
      context.transition_method_name = :cancel
      context.secondary_state = nil
    end

    organize LoadBooking,
             ResetDueDate,
             ChangeBookingState,
             ChangeSecondaryState,
             CancelBookingResourceSkus,
             PublishBookingCanceledEvent
  end
end

# frozen_string_literal: true

module Bookings
  class ReopenBooking
    include Interactor::Organizer

    before do
      context.transition_method_name = :reopen
      context.secondary_state = nil
    end

    organize LoadBooking,
             BlockBookingResourceSkus,
             ResetDueDate,
             ChangeBookingState,
             ChangeSecondaryState,
             CancelBookingResourceSkus
  end
end

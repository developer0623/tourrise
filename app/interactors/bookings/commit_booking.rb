# frozen_string_literal: true

module Bookings
  class CommitBooking
    include Interactor::Organizer

    before do
      context.transition_method_name = :commit
      context.secondary_state = nil
    end

    organize LoadBooking,
             CommitBookingResourceSkus,
             ResetDueDate,
             ChangeBookingState,
             ChangeSecondaryState,
             UnblockBookingResourceSkus,
             PublishBookingCommittedEvent
  end
end

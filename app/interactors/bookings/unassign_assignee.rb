# frozen_string_literal: true

module Bookings
  class UnassignAssignee
    include Interactor::Organizer

    before do
      context.transition_method_name = :release
      context.secondary_state = nil
    end

    organize LoadBooking,
             UpdateAssignee,
             ChangeBookingState,
             ChangeSecondaryState
  end
end

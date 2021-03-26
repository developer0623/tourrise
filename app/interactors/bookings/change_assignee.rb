# frozen_string_literal: true

module Bookings
  class ChangeAssignee
    include Interactor::Organizer

    before do
      context.transition_method_name = :process
      context.secondary_state = :offer_missing
    end

    organize LoadBooking,
             Users::LoadUser,
             UpdateAssignee,
             ChangeBookingState,
             ChangeSecondaryState,
             UnblockBookingResourceSkus
  end
end

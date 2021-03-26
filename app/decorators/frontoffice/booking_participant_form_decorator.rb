# frozen_string_literal: true

module Frontoffice
  class BookingParticipantFormDecorator < BookingFormDecorator
    def next_step_path
      h.summary_frontoffice_booking_path(
        booking_id
      )
    end

    def current_step_handle
      :participants
    end
  end
end

# frozen_string_literal: true

module Frontoffice
  class BookingAccommodationRequestFormDecorator < BookingFormDecorator
    decorates_association :booking_room_assignments, with: ::Frontoffice::BookingRoomAssignmentDecorator

    def next_step_path
      if object.booking.rooms_count.zero?
        return h.edit_frontoffice_booking_path(
          booking_id,
          step: next_step_handle
        )
      end

      h.frontoffice_booking_accommodations_path(booking_id, room: 1)
    end

    def current_step_handle
      :accommodation_request
    end
  end
end

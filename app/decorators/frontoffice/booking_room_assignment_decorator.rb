# frozen_string_literal: true

module Frontoffice
  class BookingRoomAssignmentDecorator < Draper::Decorator
    decorates "booking_room_assignment"

    delegate_all

    def selected_accommodation(room_index)
      booked_accommodations = object
                              .booking
                              .booking_resource_skus
                              .with_resource_type_id(ResourceType.accommodation.id)

      booked_accommodations[room_index - 1]
    end
  end
end

# frozen_string_literal: true

module Frontoffice
  class BookingAccommodationRequestForm < BookingFormBase
    FORM_FIELDS = %w[
      rooms_count
      booking_room_assignments_attributes
    ].freeze

    attr_accessor(*FORM_FIELDS)

    validates :rooms_count, numericality: { greater_or_equal_than: 0 }

    before_save :reset_accommodations

    def booking_room_assignments
      return booking.booking_room_assignments if booking.booking_room_assignments.any?

      []
    end

    def available_accommodations(room)
      context = LoadAvailableAccommodations.call(booking: booking, booking_room_assignment: booking_room_assignments[room.to_i - 1])

      context.success? ? context.accommodations : []
    end

    private

    def reset_accommodations
      difference = booked_rooms.count.to_i - rooms_count.to_i

      booked_rooms.each(&:destroy) unless difference.zero?
    end

    def booked_rooms
      @booked_rooms ||= booking.booking_resource_skus.with_resource_type_id(ResourceType.accommodation.id)
    end
  end
end

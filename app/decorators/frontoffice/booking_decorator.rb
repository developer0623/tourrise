# frozen_string_literal: true

module Frontoffice
  class BookingDecorator < Draper::Decorator
    decorates :booking

    delegate_all

    decorates_association :booking_room_assignments, with: Frontoffice::BookingRoomAssignmentDecorator
    decorates_association :customer, with: Frontoffice::CustomerDecorator
    decorates_association :booking_resource_skus
    decorates_association :participants, with: ParticipantDecorator
    decorates_association :booking_rentalbike_requests
    decorates_association :booking_rentalcar_requests
    decorates_association :booking_flight_requests

    def product_name
      booking.product_sku&.product&.name
    end

    def product_description
      booking.product&.description
    end

    def grouped_booking_resource_skus
      booking_resource_skus.group_by(&:resource_snapshot)
    end
  end
end

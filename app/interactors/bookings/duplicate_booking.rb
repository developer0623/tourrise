# frozen_string_literal: true

module Bookings
  class DuplicateBooking
    include Interactor

    before :load_original_booking

    def call
      context.booking = context.original_booking.dup
      context.booking.scrambled_id = ScrambledId.generate
      context.booking.duplicate_of = context.original_booking
      context.booking.aasm_state = "in_progress"
      context.booking.wishyouwhat = context.original_booking.wishyouwhat
      context.booking.title = context.original_booking.title

      clone_associations

      context.fail!(message: context.booking.errors.full_messages) unless context.booking.save(validate: false)

      ChangeSecondaryState.call(booking: context.booking, secondary_state: :offer_missing)
    end

    private

    def load_original_booking
      original_booking_context = LoadBooking.call(booking_id: context.original_booking_id)
      context.fail!(message: "original booking not found") unless original_booking_context.success?

      context.original_booking = original_booking_context.booking
    end

    def clone_associations
      clone_participants
      clone_booking_resource_skus
      clone_tags
      clone_booking_flight_requests
      clone_booking_rentalbike_requests
      clone_booking_rentalcar_requests
    end

    def clone_participants
      context.booking.participants = context.original_booking.participants.map(&:dup)
    end

    def clone_booking_resource_skus
      return unless context.original_booking.booking_resource_skus.any?

      context.booking.booking_resource_skus = context.original_booking.booking_resource_skus.map do |booking_resource_sku|
        clone_booking_resource_sku(booking_resource_sku)
      end
    end

    def clone_booking_resource_sku(booking_resource_sku)
      duplicated_booking_resource_sku = booking_resource_sku.dup
      duplicated_booking_resource_sku.availability = booking_resource_sku.availability
      duplicated_booking_resource_sku.internal = false
      duplicated_booking_resource_sku.booking_attribute_values = booking_resource_sku.booking_attribute_values.map(&:dup)
      duplicated_booking_resource_sku.flights = booking_resource_sku.flights.map(&:dup)
      duplicated_booking_resource_sku
    end

    def clone_tags
      return unless context.original_booking.tags.any?

      context.booking.tags = context.original_booking.tags
    end

    def clone_booking_flight_requests
      return unless context.original_booking.booking_flight_requests.any?

      context.booking.booking_flight_requests = context.original_booking.booking_flight_requests.map(&:dup)
    end

    def clone_booking_rentalbike_requests
      return unless context.original_booking.booking_rentalbike_requests.any?

      context.booking.booking_rentalbike_requests = context.original_booking.booking_rentalbike_requests.map(&:dup)
    end

    def clone_booking_rentalcar_requests
      return unless context.original_booking.booking_rentalcar_requests.any?

      context.booking.booking_rentalcar_requests = context.original_booking.booking_rentalcar_requests.map(&:dup)
    end
  end
end

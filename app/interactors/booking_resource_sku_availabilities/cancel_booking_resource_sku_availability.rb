# frozen_string_literal: true

module BookingResourceSkuAvailabilities
  class CancelBookingResourceSkuAvailability
    include Interactor

    attr_accessor :memoized_state, :memoized_booking_resource_sku_availability

    before :memoize_state

    def call
      context.fail!(message: context.booking_resource_sku_availability.errors.full_messages) unless context.booking_resource_sku_availability.update(
        booked_by_id: nil,
        booked_at: nil
      )
    end

    def rollback
      memoized_booking_resource_sku_availability.update(memoized_state)
    end

    private

    def memoize_state
      self.memoized_booking_resource_sku_availability = context.booking_resource_sku_availability
      self.memoized_state = context.booking_resource_sku_availability.attributes.slice("booked_by_id", "booked_at")
    end
  end
end

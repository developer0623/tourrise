# frozen_string_literal: true

module BookingResourceSkuAvailabilities
  class BlockBookingResourceSkuAvailability
    include Interactor

    attr_accessor :memoized_booking_resource_sku_availability

    before do
      self.memoized_booking_resource_sku_availability = context.booking_resource_sku_availability
    end

    def call
      context.fail!(message: context.booking_resource_sku_availability.errors.full_messages) unless context.booking_resource_sku_availability.update(
        blocked_by_id: context.user_id,
        blocked_at: Time.zone.now
      )
    end

    def rollback
      memoized_booking_resource_sku_availability.update(
        blocked_by_id: nil,
        blocked_at: nil
      )
    end
  end
end

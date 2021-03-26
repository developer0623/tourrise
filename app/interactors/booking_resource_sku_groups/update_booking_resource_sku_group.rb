# frozen_string_literal: true

module BookingResourceSkuGroups
  class UpdateBookingResourceSkuGroup
    include Interactor

    delegate :booking_resource_sku_group, :booking, to: :context

    before do
      context.booking_resource_sku_group = BookingResourceSkuGroup.find(context.booking_resource_sku_group_id)
      context.booking = booking_resource_sku_group.booking
    end

    def call
      context.fail!(message: booking_resource_sku_group.errors.full_messages) unless booking_resource_sku_group.update(update_params)

      Bookings::ChangeSecondaryState.call(booking: booking, secondary_state: :offer_missing) if booking_resource_sku_group.price_cents_changed?
    end

    private

    def update_params
      context.params
    end
  end
end

# frozen_string_literal: true

module BookingResourceSkus
  class DeleteBookingResourceSku
    include Interactor

    before do
      Bookings::LoadBooking.call(context)
      LoadBookingResourceSku.call(context)
    end

    def call
      check_group_association

      context.fail!(message: context.booking_resource_sku.errors.full_messages) unless context.booking_resource_sku.destroy

      Bookings::ChangeSecondaryState.call(booking: context.booking, secondary_state: :offer_missing)
    end

    private

    def check_group_association
      return unless context.booking.booking_resource_sku_groups.any?

      context.booking.booking_resource_sku_groups.each do |group|
        next unless group.booking_resource_sku_ids.include?(context.booking_resource_sku.id) && (group.booking_resource_sku_ids.count == 1)

        delete_group_context = BookingResourceSkuGroups::DeleteBookingResourceSkuGroup.call(booking_resource_sku_group_id: group.id, booking: context.booking)

        context.fail!(message: delete_group_context.message) if delete_group_context.failure?
      end
    end
  end
end

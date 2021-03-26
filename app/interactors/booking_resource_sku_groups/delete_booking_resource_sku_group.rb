# frozen_string_literal: true

module BookingResourceSkuGroups
  class DeleteBookingResourceSkuGroup
    include Interactor

    delegate :booking_resource_sku_group, :booking, to: :context

    before do
      context.booking_resource_sku_group ||= BookingResourceSkuGroup.find_by(id: context.booking_resource_sku_group_id)
      context.booking ||= booking_resource_sku_group.booking
    end

    def call
      return true if booking_resource_sku_group.nil?

      context.fail!(message: I18n.t("booking_resource_sku_groups.destroy.cannot_show_booking_resource_skus")) unless show_skus

      context.fail!(message: booking_resource_sku_group.errors.full_messages) unless booking_resource_sku_group.destroy

      Bookings::ChangeSecondaryState.call(booking: booking, secondary_state: :offer_missing)
    end

    private

    def show_skus
      BookingResourceSku.transaction do
        booking.booking_resource_skus.where(
          id: booking_resource_sku_group.booking_resource_sku_ids
        ).each do |booking_resource_sku|
          raise ActiveRecord::Rollback unless booking_resource_sku.update_attribute(:internal, false)
        end
      end
    end
  end
end

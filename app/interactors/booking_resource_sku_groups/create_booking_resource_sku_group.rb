# frozen_string_literal: true

module BookingResourceSkuGroups
  class CreateBookingResourceSkuGroup
    include Interactor

    delegate :booking, to: :context

    def call
      context.booking_resource_sku_group = BookingResourceSkuGroup.new(create_params)

      context.fail!(message: I18n.t("booking_resource_sku_groups.create.must_add_booking_resource_skus")) unless context.booking_resource_sku_group.booking_resource_sku_ids.any?

      context.fail!(message: I18n.t("booking_resource_sku_groups.create.fail_booking_booked")) if context.booking.booked?

      context.fail!(message: I18n.t("booking_resource_sku_groups.create.cannot_hide_booking_resource_skus")) unless hide_skus

      context.fail!(message: context.booking_resource_sku_group.errors.full_messages) unless context.booking_resource_sku_group.save

      Bookings::ChangeSecondaryState.call(booking: booking, secondary_state: :offer_missing)
    end

    private

    def create_params
      create_params = context.params.slice("name", "financial_account_id", "cost_center_id", "booking_resource_sku_ids", "allow_partial_payment")

      create_params["booking_id"] = context.booking.id
      create_params["price_cents"] = context.params["price"].delete("^0-9")
      create_params["price_currency"] = MoneyRails.default_currency

      create_params
    end

    def hide_skus
      BookingResourceSku.transaction do
        context.booking.booking_resource_skus.where(
          id: context.booking_resource_sku_group.booking_resource_sku_ids
        ).each do |booking_resource_sku|
          raise ActiveRecord::Rollback unless booking_resource_sku.update(internal: true)
        end
      end
    end
  end
end

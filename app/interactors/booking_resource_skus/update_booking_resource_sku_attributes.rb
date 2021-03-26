# frozen_string_literal: true

module BookingResourceSkus
  class UpdateBookingResourceSkuAttributes
    include Interactor

    before :validate_booking_resource_sku_context

    def call
      context.booking_resource_sku.assign_attributes(context.params)

      context.booking_resource_sku.booking_attribute_values.each do |booking_attribute_value|
        booking_attribute_value.mark_for_destruction if booking_attribute_value.blank?
      end
    end

    private

    def validate_booking_resource_sku_context
      context.fail!(message: I18n.t(".booking_resource_sku_missing")) unless context.booking_resource_sku.present?
    end
  end
end

# frozen_string_literal: true

module Frontoffice
  class BookingResourceSkuRequestFormBase < BookingFormBase
    FORM_FIELDS = %w[booking_resource_skus_attributes].freeze

    attr_accessor(*FORM_FIELDS)

    delegate :booking_resource_skus, to: :booking

    before_save :mark_booking_resource_skus_for_destruction
    before_save :update_booking_resource_skus_prices

    def booking_resource_skus_attributes
      @booking_resource_skus_attributes ||= {}
    end

    private

    def mark_booking_resource_skus_for_destruction
      booking_resource_skus.each do |booking_resource_sku|
        found_booking_resource_sku_attributes = find_booking_resource_sku_attributes_for_destruction(booking_resource_sku)

        next unless found_booking_resource_sku_attributes.present?

        booking_resource_sku.mark_for_destruction if found_booking_resource_sku_attributes["quantity"].to_i.zero?
      end
    end

    def update_booking_resource_skus_prices
      booking_resource_skus.each do |booking_resource_sku|
        next unless booking_resource_sku.changed?

        starts_on = booking_resource_sku.starts_on || booking.starts_on
        ends_on = booking_resource_sku.ends_on || booking.ends_on

        context = Pricings::ResourceSku::CalculateTotalPrice.call(
          resource_sku: booking_resource_sku.resource_sku,
          starts_on: starts_on,
          ends_on: ends_on,
          adults: booking_resource_sku.quantity
        )

        next if context.failure?

        booking_resource_sku.price = context.price / booking_resource_sku.quantity
      end
    end

    def find_booking_resource_sku_attributes_for_destruction(booking_resource_sku)
      _index, found_booking_resource_sku_attributes = booking_resource_skus_attributes.find do |_, booking_resource_sku_attributes|
        next unless booking_resource_sku.persisted?

        booking_resource_sku_attributes["id"].to_i == booking_resource_sku.id.to_i
      end

      found_booking_resource_sku_attributes
    end
  end
end

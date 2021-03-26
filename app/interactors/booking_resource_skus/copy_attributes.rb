# frozen_string_literal: true

module BookingResourceSkus
  class CopyAttributes
    include Interactor

    def call
      copy_attributes
      copy_booking_attribute_values
      copy_booking_resource_sku_availability
      copy_flights

      context.fail!(message: context.new_booking_resource_sku.errors.full_messages) unless context.new_booking_resource_sku.save
    end

    private

    def copy_attributes
      duplicated_attributes = context.booking_resource_sku.attributes.dup
      duplicated_attributes.delete("id")

      context.new_booking_resource_sku.attributes = duplicated_attributes
    end

    def copy_booking_attribute_values
      booking_attribute_values = context.booking_resource_sku.booking_attribute_values.map(&:attributes).dup

      booking_attribute_values = booking_attribute_values.map do |booking_attribute_value|
        BookingAttributeValue.new(
          booking_attribute_value.slice("booking_attribute_id", "name", "attribute_type", "value", "handle")
        )
      end

      context.new_booking_resource_sku.booking_attribute_values = booking_attribute_values
    end

    def copy_flights
      flights = context.booking_resource_sku.flights.map(&:dup)

      context.new_booking_resource_sku.flights = flights
    end

    def copy_booking_resource_sku_availability
      return unless context.booking_resource_sku.booking_resource_sku_availability.present?

      context.new_booking_resource_sku.booking_resource_sku_availability = context.booking_resource_sku.booking_resource_sku_availability.dup
    end
  end
end

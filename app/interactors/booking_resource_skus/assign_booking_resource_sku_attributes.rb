# frozen_string_literal: true

module BookingResourceSkus
  class AssignBookingResourceSkuAttributes
    include Interactor

    before :validate_booking_resource_sku_context

    def call
      context.booking_resource_sku.assign_attributes(
        booking: context.booking,
        resource_sku: context.resource_sku,
        quantity: 1,
        price: context.params.dig("booking_resource_sku", "price")
      )

      assign_booking_attribute_values
      assign_participants
      copy_data_from_resource_sku
    end

    private

    def validate_booking_resource_sku_context
      context.fail!(message: I18n.t("booking_resource_skus.assign_booking_resource_sku_attributes.booking_resource_sku_missing")) unless context.booking_resource_sku.present?
    end

    def assign_booking_attribute_values
      return unless context.resource_sku.resource_type.with_date_range?

      starts_on_booking_attribute = context.resource_sku.resource_type.booking_attributes.find_by_handle(:starts_on)
      ends_on_booking_attribute = context.resource_sku.resource_type.booking_attributes.find_by_handle(:ends_on)

      context.booking_resource_sku.booking_attribute_values.new(
        booking_attribute: starts_on_booking_attribute,
        attribute_type: starts_on_booking_attribute.attribute_type,
        name: starts_on_booking_attribute.name,
        handle: starts_on_booking_attribute.handle,
        value: context.params.dig("booking_resource_sku", "starts_on")
      )

      context.booking_resource_sku.booking_attribute_values.new(
        booking_attribute: ends_on_booking_attribute,
        attribute_type: ends_on_booking_attribute.attribute_type,
        name: ends_on_booking_attribute.name,
        handle: ends_on_booking_attribute.handle,
        value: context.params.dig("booking_resource_sku", "ends_on")
      )
    end

    def assign_participants
      return if context.params.blank?

      if context.params.dig("booking_resource_sku", "participant_ids").blank?
        context.booking_resource_sku.participant_ids = context.booking.participants.pluck(:id) if context.booking.people_count == 1
      else
        context.booking_resource_sku.participant_ids = context.params["booking_resource_sku"]["participant_ids"]
      end
    end

    def copy_data_from_resource_sku
      context.booking_resource_sku.allow_partial_payment = context.resource_sku.allow_partial_payment

      case context.resource_sku.resource_type.handle.to_sym
      when :flight
        context.booking_resource_sku.flight_ids = context.resource_sku.flights.pluck(:id)
      end
    end
  end
end

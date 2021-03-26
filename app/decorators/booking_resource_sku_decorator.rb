# frozen_string_literal: true

class BookingResourceSkuDecorator < Draper::Decorator
  delegate_all

  decorates_association :booking
  decorates_association :participants, with: ParticipantDecorator
  decorates_association :booking_attribute_values
  decorates_association :invoices
  decorates_association :cancellation

  def display_details?
    object.booking_attribute_values.any?
  end

  def additional_details?
    secondary_attribute_values.any? || object.flights.any? || object.remarks.present?
  end

  def additional_details
    secondary_attribute_values.sort_by { |attribute_value| BookingAttribute::DEFAULT_SORT_ORDER.find_index(attribute_value.handle) || -1 }
  end

  def missing_booking_attribute_values
    return [] if booking_attributes.blank?

    booking_attributes.map do |attribute|
      next unless attribute.required?

      booking_attribute_value = object.booking_attribute_values.find_by(booking_attribute_id: attribute.id)
      next if booking_attribute_value.present? && booking_attribute_value.value.present?

      attribute
    end.flatten.compact
  end

  def missing_details?
    return false if booking_attributes.blank?

    missing_booking_attribute_values.any?
  end

  def booking_attributes
    return [] unless resource_type.present?

    resource_type.booking_attributes
  end

  def editable_by_user?
    return false if h.current_user.id == FrontofficeUser.id

    object.persisted? && !object.grouped?
  end

  def removeable_by_user?
    return false if h.current_user.id == FrontofficeUser.id

    object.persisted?
  end

  def removeable?
    removeable_by_user? && !canceled? && !object.grouped?
  end

  def resource_name
    object.persisted? ? object.resource_snapshot["name"] : object.resource.name
  end

  def name
    object.persisted? ? object.resource_sku_snapshot["name"] : object.resource_sku.name
  end

  def handle
    object.persisted? ? object.resource_sku_snapshot["handle"] : object.resource_sku.handle
  end

  def nights
    booking.nights
  end

  def resource_type_handle
    resource_type.handle
  end

  def bookable?
    booking_resource_sku_service.bookable?
  end

  def blockable?
    booking_resource_sku_service.blockable?
  end

  def availability_blocked?
    return false unless object.booking_resource_sku_availability.present?

    object.booking_resource_sku_availability.blocked?
  end

  def availability_booked?
    return false unless object.booking_resource_sku_availability.present?

    object.booking_resource_sku_availability.booked?
  end

  def availability_blocked_by
    return "" unless object.booking_resource_sku_availability.present?

    [
      object.booking_resource_sku_availability.blocked_by.first_name,
      object.booking_resource_sku_availability.blocked_by.last_name
    ].join(" ")
  end

  def availability_booked_by
    return "" unless object.booking_resource_sku_availability.present?

    [
      object.booking_resource_sku_availability.booked_by.first_name,
      object.booking_resource_sku_availability.booked_by.last_name
    ].join(" ")
  end

  def potential_availability_slots
    return [] unless object.resource_sku.present?

    object.resource_sku.availabilities.decorate.select do |availability|
      next true if availability.id == object.availability&.id

      availability_service = AvailabilityService.new(availability)

      availability_service.available?(object.required_quantity, object.starts_on, object.ends_on)
    end
  end

  def show_error_messages?
    object.booking.in_progress? && !committable?
  end

  def committable?
    object.valid? && validator.valid?
  end

  def validation_error_messages
    object.errors.full_messages + validator.errors.full_messages
  end

  def date_range
    return unless with_date_range?

    date_format =
      if (starts_on.year != ends_on.year) || (starts_on.year != Time.current.year)
        :long
      else
        :short
      end

    date_range = h.distance_of_time_in_words(starts_on, ends_on)
    date_range += " (#{h.l(starts_on, format: date_format)} - #{h.l(ends_on, format: date_format)})"

    date_range
  end

  def display_quantity
    "#{object.quantity} &times;".html_safe
  end

  private

  def validator
    @validator ||= BookingResourceSkuValidator.new(object)
  end

  def booking_resource_sku_service
    @booking_resource_sku_service ||= BookingResourceSkuService.new(object)
  end

  def secondary_attribute_values
    object.booking_attribute_values.where.not(handle: %i[starts_on ends_on start_time end_time]).where.not(value: [nil, ""])
  end
end

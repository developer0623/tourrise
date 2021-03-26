# frozen_string_literal: true

class AvailabilityDecorator < Draper::Decorator
  delegate_all

  def label
    "#{date_range(format: :short)} (#{available_quantity(starts_on: object.starts_on, ends_on: object.ends_on)}/#{quantity})"
  end

  def as_select_option
    [
      "#{inventory_name} - #{inventory_type} - #{available_quantity(starts_on: object.starts_on, ends_on: object.ends_on)}/#{quantity} #{date_range}",
      object.id
    ]
  end

  def inventory_name
    object.inventory.name
  end

  def available_quantity(starts_on: nil, ends_on: nil)
    availability_service.available_quantity(starts_on, ends_on)
  end

  def availability_reducing_booking_resource_skus
    object.booking_resource_skus.availability_reducing
  end

  def date_range(format: :long)
    return unless starts_on.present? && ends_on.present?

    "#{l(object.starts_on, format: format)} - #{l(object.ends_on, format: format)}"
  end

  private

  def availability_service
    @availability_service ||= AvailabilityService.new(object)
  end
end

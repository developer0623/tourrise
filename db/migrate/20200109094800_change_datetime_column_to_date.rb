class ChangeDatetimeColumnToDate < ActiveRecord::Migration[6.0]
  class Booking < ApplicationRecord; end;
  class BookingFlightRequest < ApplicationRecord
    scope :with_date_range, -> { where.not(starts_at: nil, ends_at: nil) }
  end
  class BookingRentalbikeRequest < ApplicationRecord
    scope :with_date_range, -> { where.not(starts_at: nil, ends_at: nil) }
  end
  class Availability < ApplicationRecord
    scope :with_date_range, -> { where.not(starts_at: nil, ends_at: nil) }
  end
  class ProductSkuBookingConfiguration < ApplicationRecord
    scope :with_date_range, -> { where.not(starts_at: nil, ends_at: nil) }
  end

  def up
    ActiveRecord::Base.transaction do
      bookings_fix_datetime_utc_offset
      availabilities_fix_datetime_utc_offset
      booking_flight_requests_fix_datetime_utc_offset
      booking_rentalbike_requests_fix_datetime_utc_offset
      product_sku_booking_configuration_fix
    end

    rename_column :bookings, :starts_at, :starts_on
    change_column :bookings, :starts_on, :date

    rename_column :bookings, :ends_at, :ends_on
    change_column :bookings, :ends_on, :date

    ResourceType.where(handle: %i[accommodation rentalbike]).each do |resource_type|
      starts_at_attribute = resource_type.booking_attributes.find_by_handle(:starts_at)
      ends_at_attribute = resource_type.booking_attributes.find_by_handle(:ends_at)

      change_booking_attribute_type(starts_at_attribute, :starts_at, :starts_on, BookingAttribute::DATE)
      change_booking_attribute_type(ends_at_attribute, :ends_at, :ends_on, BookingAttribute::DATE)
    end

    rename_column :availabilities, :starts_at, :starts_on
    change_column :availabilities, :starts_on, :date
    rename_column :availabilities, :ends_at, :ends_on
    change_column :availabilities, :ends_on, :date

    rename_column :booking_flight_requests, :starts_at, :starts_on
    change_column :booking_flight_requests, :starts_on, :date
    rename_column :booking_flight_requests, :ends_at, :ends_on
    change_column :booking_flight_requests, :ends_on, :date

    rename_column :booking_rentalbike_requests, :starts_at, :starts_on
    change_column :booking_rentalbike_requests, :starts_on, :date
    rename_column :booking_rentalbike_requests, :ends_at, :ends_on
    change_column :booking_rentalbike_requests, :ends_on, :date

    rename_column :product_sku_booking_configurations, :starts_at, :starts_on
    change_column :product_sku_booking_configurations, :starts_on, :date
    rename_column :product_sku_booking_configurations, :ends_at, :ends_on
    change_column :product_sku_booking_configurations, :ends_on, :date

    if ResourceType.accommodation.present?
      accommodation_resource_type = ResourceType.accommodation

      ResourceTypes::SetupResourceTypeAccommodation.call

      BookingResourceSku.with_resource_type_id(accommodation_resource_type.id).each do |booking_resource_sku|
        starts_on_attribute = accommodation_resource_type.booking_attributes.find_by_handle(:starts_on)

        if starts_on_attribute
          attribute_value = booking_resource_sku.booking_attribute_values.find_or_initialize_by(booking_attribute_id: starts_on_attribute.id)
          attribute_value.value = booking_resource_sku.booking.starts_on
          attribute_value.name = starts_on_attribute.name
          attribute_value.attribute_type = starts_on_attribute.attribute_type
          attribute_value.handle = starts_on_attribute.handle
          attribute_value.save
        end

        ends_on_attribute = accommodation_resource_type.booking_attributes.find_by_handle(:ends_on)

        if ends_on_attribute
          attribute_value = booking_resource_sku.booking_attribute_values.find_or_initialize_by(booking_attribute_id: ends_on_attribute.id)
          attribute_value.value = booking_resource_sku.booking.ends_on
          attribute_value.name = ends_on_attribute.name
          attribute_value.attribute_type = ends_on_attribute.attribute_type
          attribute_value.handle = ends_on_attribute.handle
          attribute_value.save
        end

        booking_resource_sku.save
      end
    end
  end

  def down
    rename_column :bookings, :starts_on, :starts_at
    change_column :bookings, :starts_at, :datetime

    rename_column :bookings, :ends_on, :ends_at
    change_column :bookings, :ends_at, :datetime

    ResourceType.where(handle: %i[accommodation rentalbike]).each do |resource_type|
      starts_on_attribute = resource_type.booking_attributes.find_by_handle(:starts_on)
      ends_on_attribute = resource_type.booking_attributes.find_by_handle(:ends_on)

      change_booking_attribute_type(starts_at_attribute, :starts_on, :starts_at, BookingAttribute::DATETIME)
      change_booking_attribute_type(ends_at_attribute, :ends_on, :ends_at, BookingAttribute::DATETIME)
    end
  end

  def change_booking_attribute_type(booking_attribute, old, new, attribute_type)
    return unless booking_attribute.present?

    booking_attribute.update(
      attribute_type: attribute_type,
      name: I18n.t("booking_attributes.#{new}"),
      handle: new
    )

    booking_attribute_value = booking_attribute.booking_attribute_values.find_by_handle(old)
    change_booking_attribute_value(booking_attribute_value, new, attribute_type)
  end

  def change_booking_attribute_value(booking_attribute_value, new, attribute_type)
    return unless booking_attribute_value.present?

    new_value = booking_attribute_value.value

    case attribute_type
    when BookingAttribute::DATE
      new_value = new_value.to_date
    when BookingAttribute::DATETIME
      new_value = new_value.to_datetime
    end

    booking_attribute_value.update(
      attribute_type: attribute_type,
      name: I18n.t("booking_attributes.#{new}"),
      value: new_value,
      handle: new
    )
  end

  def bookings_fix_datetime_utc_offset
    Booking.transaction do
      Booking.all.each do |booking|
        update_record(booking)
      end
    end
  end

  def availabilities_fix_datetime_utc_offset
    Availability.with_date_range.each do |availability|
      update_record(availability)
    end
  end

  def booking_flight_requests_fix_datetime_utc_offset
    BookingFlightRequest.with_date_range.each do |record|
      update_record(record)
    end
  end

  def booking_rentalbike_requests_fix_datetime_utc_offset
    BookingRentalbikeRequest.with_date_range.each do |record|
      update_record(record)
    end
  end

  def product_sku_booking_configuration_fix
    ProductSkuBookingConfiguration.with_date_range.each do |record|
      update_record(record)
    end
  end

  def update_record(record)
    starts_at_difference = record.starts_at.utc.hour - 24
    ends_at_difference = record.ends_at.utc.hour - 24

    if starts_at_difference.negative?
      new_starts_at = record.starts_at + starts_at_difference.abs.hours
      record.starts_at = new_starts_at
    end

    if ends_at_difference.negative?
      new_ends_at = record.ends_at + ends_at_difference.abs.hours
      record.ends_at = new_ends_at
    end

    raise 'fuck' if record.starts_at.day != record.starts_at.utc.day
    raise 'fuck' if record.ends_at.day != record.ends_at.utc.day

    record.save
  end
end

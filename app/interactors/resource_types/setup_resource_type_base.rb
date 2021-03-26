# frozen_string_literal: true

module ResourceTypes
  class SetupResourceTypeBase
    include Interactor

    private

    def setup(handle)
      context.resource_type = ResourceType.find_or_initialize_by(handle: handle) do |new_resource_type|
        new_resource_type.label = I18n.t("resource_types.#{handle}")
      end
    end

    def save
      context.fail!(message: context.resource_type.errors.full_messages) unless context.resource_type.save
    end

    def add_height
      context.resource_type.booking_attributes.find_or_initialize_by(handle: :height) do |booking_attribute|
        booking_attribute.attribute_type = BookingAttribute::NUMBER
        booking_attribute.name = I18n.t("booking_attributes.height")
      end
    end

    def add_reservation_number
      context.resource_type.booking_attributes.find_or_initialize_by(handle: :reservation_number) do |booking_attribute|
        booking_attribute.attribute_type = BookingAttribute::STRING
        booking_attribute.name = I18n.t("booking_attributes.reservation_number")
      end
    end

    def add_start_date(required: true)
      context.resource_type.booking_attributes.find_or_initialize_by(handle: :starts_on) do |booking_attribute|
        booking_attribute.attribute_type = BookingAttribute::DATE
        booking_attribute.name = I18n.t("booking_attributes.starts_on")
        booking_attribute.required = required
      end
    end

    def add_end_date(required: true)
      context.resource_type.booking_attributes.find_or_initialize_by(handle: :ends_on) do |booking_attribute|
        booking_attribute.attribute_type = BookingAttribute::DATE
        booking_attribute.name = I18n.t("booking_attributes.ends_on")
        booking_attribute.required = required
      end
    end

    def add_start_time(required: true)
      context.resource_type.booking_attributes.find_or_initialize_by(handle: :start_time) do |booking_attribute|
        booking_attribute.attribute_type = BookingAttribute::TIME
        booking_attribute.name = I18n.t("booking_attributes.start_time")
        booking_attribute.required = required
      end
    end

    def add_end_time(required: true)
      context.resource_type.booking_attributes.find_or_initialize_by(handle: :end_time) do |booking_attribute|
        booking_attribute.attribute_type = BookingAttribute::TIME
        booking_attribute.name = I18n.t("booking_attributes.end_time")
        booking_attribute.required = required
      end
    end

    def add_starts_at
      context.resource_type.booking_attributes.find_or_initialize_by(handle: :starts_at) do |booking_attribute|
        booking_attribute.attribute_type = BookingAttribute::DATETIME
        booking_attribute.name = I18n.t("booking_attributes.starts_at")
        booking_attribute.required = true
      end
    end

    def add_ends_at
      context.resource_type.booking_attributes.find_or_initialize_by(handle: :ends_at) do |booking_attribute|
        booking_attribute.attribute_type = BookingAttribute::DATETIME
        booking_attribute.name = I18n.t("booking_attributes.ends_at")
        booking_attribute.required = true
      end
    end

    def add_pickup_location
      context.resource_type.booking_attributes.find_or_initialize_by(handle: :pickup_location) do |booking_attribute|
        booking_attribute.attribute_type = BookingAttribute::STRING
        booking_attribute.name = I18n.t("booking_attributes.pickup_location")
        booking_attribute.required = true
      end
    end

    def add_dropoff_location
      context.resource_type.booking_attributes.find_or_initialize_by(handle: :dropoff_location) do |booking_attribute|
        booking_attribute.attribute_type = BookingAttribute::STRING
        booking_attribute.name = I18n.t("booking_attributes.dropoff_location")
        booking_attribute.required = true
      end
    end
  end
end

# frozen_string_literal: true

module ResourceTypes
  class SetupResourceTypeTransfer < SetupResourceTypeBase
    def call
      setup(:transfer)

      add_start_date
      add_start_time
      add_pickup_location
      add_dropoff_location
      add_reservation_number
      add_reference

      save
    end

    private

    def add_reference
      context.resource_type.booking_attributes.find_or_initialize_by(handle: :reference) do |booking_attribute|
        booking_attribute.attribute_type = BookingAttribute::STRING
        booking_attribute.name = I18n.t("booking_attributes.reference")
      end
    end
  end
end

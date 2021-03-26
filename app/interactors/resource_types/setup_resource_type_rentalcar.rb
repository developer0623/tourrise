# frozen_string_literal: true

module ResourceTypes
  class SetupResourceTypeRentalcar < SetupResourceTypeBase
    def call
      setup(:rentalcar)

      add_starts_at
      add_ends_at
      add_reservation_number
      add_pickup_location
      add_dropoff_location
      add_rentalcar_type

      save
    end

    private

    def add_rentalcar_type
      context.resource_type.booking_attributes.find_or_initialize_by(handle: :rentalcar_type) do |booking_attribute|
        booking_attribute.attribute_type = BookingAttribute::STRING
        booking_attribute.name = I18n.t("booking_attributes.rentalcar_type")
        booking_attribute.required = true
      end
    end
  end
end

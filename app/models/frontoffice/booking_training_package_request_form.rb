# frozen_string_literal: true

module Frontoffice
  class BookingTrainingPackageRequestForm < BookingResourceSkuRequestFormBase
    before_save :add_starts_on
    before_save :add_ends_on

    def training_packages
      resource_type = ResourceType.find_by(handle: :training_package)

      product_sku.resources.where(resource_type_id: resource_type)
    end

    private

    def add_starts_on
      starts_on_attribute = ResourceType.training_package.booking_attributes.find_by(handle: :starts_on)

      booking_resource_skus.each do |booking_resource_sku|
        booking_resource_sku.booking_attribute_values.find_or_initialize_by(handle: starts_on_attribute.handle) do |booking_attribute_value|
          booking_attribute_value.booking_attribute = starts_on_attribute
          booking_attribute_value.name = starts_on_attribute.name
          booking_attribute_value.value = booking_resource_sku.booking.starts_on
        end
      end
    end

    def add_ends_on
      ends_on_attribute = ResourceType.training_package.booking_attributes.find_by(handle: :ends_on)

      booking_resource_skus.each do |booking_resource_sku|
        booking_resource_sku.booking_attribute_values.find_or_initialize_by(handle: ends_on_attribute.handle) do |booking_attribute_value|
          booking_attribute_value.booking_attribute = ends_on_attribute
          booking_attribute_value.name = ends_on_attribute.name
          booking_attribute_value.value = booking_resource_sku.booking.ends_on
        end
      end
    end
  end
end

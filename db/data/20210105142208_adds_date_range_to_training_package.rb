class AddsDateRangeToTrainingPackage < ActiveRecord::Migration[6.0]
  def up
    return if ResourceType.training_package.blank?

    ResourceTypes::SetupResourceTypeTrainingPackage.call

    BookingResourceSku.with_resource_type_id(ResourceType.training_package.id).each do |booking_resource_sku|
      starts_on_attribute = ResourceType.training_package.booking_attributes.find_by(handle: :starts_on)
      ends_on_attribute = ResourceType.training_package.booking_attributes.find_by(handle: :ends_on)

      booking_resource_sku.booking_attribute_values.find_or_create_by!(booking_attribute: starts_on_attribute) do |booking_attribute_value|
        booking_attribute_value.name = starts_on_attribute.name
        booking_attribute_value.value = booking_resource_sku.booking.starts_on
      end

      booking_resource_sku.booking_attribute_values.find_or_create_by!(booking_attribute: ends_on_attribute) do |booking_attribute_value|
        booking_attribute_value.name = ends_on_attribute.name
        booking_attribute_value.value = booking_resource_sku.booking.ends_on
      end

      booking_resource_sku.save
    end
  end

  def down
    return if ResourceType.training_package.blank?

    BookingResourceSku.with_resource_type_id(ResourceType.training_package.id).each do |booking_resource_sku|
      booking_resource_sku.booking_attribute_values.find_by(handle: :starts_on)&.destroy
      booking_resource_sku.booking_attribute_values.find_by(handle: :ends_on)&.destroy
    end

    ResourceType.training_package.booking_attributes.find_by(handle: :starts_on).destroy
    ResourceType.training_package.booking_attributes.find_by(handle: :ends_on).destroy
  end
end

class AddStartsOnAndEndsOnToBookingResourceSkus < ActiveRecord::Migration[6.0]
  def change
    add_column :booking_resource_skus, :starts_on, :date
    add_column :booking_resource_skus, :ends_on, :date

    BookingResourceSku.unscoped.all.each do |booking_resource_sku|
      next unless booking_resource_sku.with_date_range?

      booking_resource_sku.update(
        starts_on: booking_resource_sku.booking_attribute_values.find_by_handle(:starts_on).value,
        ends_on: booking_resource_sku.booking_attribute_values.find_by_handle(:ends_on).value
      )
    end
  end
end

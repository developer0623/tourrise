class UpdateStartsAtEndsAtForAccommodationBookings < ActiveRecord::Migration[6.0]
  def change
    add_column :booking_attribute_values, :handle, :string, null: false

    BookingAttributeValue.all.each do |booking_attribute_value|
      booking_attribute_value.update_attribute(:handle, booking_attribute_value.booking_attribute&.handle)
    end

    add_index :booking_attribute_values, [:booking_resource_sku_id, :handle], unique: true, name: 'idx_b_attr_vals_on_b_res_sku_id_and_handle'
  end
end

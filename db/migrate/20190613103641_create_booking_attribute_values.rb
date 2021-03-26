class CreateBookingAttributeValues < ActiveRecord::Migration[5.2]
  def change
    create_table :booking_attribute_values do |t|
      t.references :booking_attribute
      t.references :booking_resource_sku

      t.string :name, null: false
      t.string :attribute_type, null: false

      t.text :value

      t.timestamps
    end
  end
end

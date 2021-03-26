class CreateBookingAttributes < ActiveRecord::Migration[5.2]
  def change
    create_table :booking_attributes do |t|
      t.references :resource_type

      t.string :attribute_type, default: 'text', null: false
      t.string :name, null: false
      t.string :handle, null: false, index: true

      t.boolean :required, default: false

      t.timestamps
    end
  end
end

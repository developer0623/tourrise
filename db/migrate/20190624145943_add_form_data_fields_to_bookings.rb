class AddFormDataFieldsToBookings < ActiveRecord::Migration[5.2]
  def change
    add_column :bookings, :rooms_count, :integer

    create_table :booking_room_assignments do |t|
      t.references :booking

      t.integer :adults
      t.integer :kids
      t.integer :babies

      t.timestamps
    end
  end
end

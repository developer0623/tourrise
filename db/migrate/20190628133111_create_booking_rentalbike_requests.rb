class CreateBookingRentalbikeRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :booking_rentalbike_requests do |t|
      t.references :booking

      t.datetime :starts_at
      t.datetime :ends_at
      t.integer :height

      t.timestamps
    end

    add_column :bookings, :rentalbikes_count, :integer
  end
end

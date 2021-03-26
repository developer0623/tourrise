class CreateBookingFlightRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :booking_flight_requests do |t|
      t.references :booking

      t.datetime :starts_at
      t.datetime :ends_at
      t.string :destination_airport
      t.string :departure_airport

      t.timestamps
    end
  end
end

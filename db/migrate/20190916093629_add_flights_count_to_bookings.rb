class AddFlightsCountToBookings < ActiveRecord::Migration[6.0]
  def up
    add_column :bookings, :flights_count, :integer

    Booking.all.each do |booking|
      booking.update_attribute(:flights_count, booking.booking_flight_requests.count)
    end
  end

  def down
    remove_column :bookings, :flights_count, :integer
  end
end

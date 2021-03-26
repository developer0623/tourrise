class AddSeasonToBookings < ActiveRecord::Migration[6.0]
  def change
    add_reference :bookings, :season
  end
end

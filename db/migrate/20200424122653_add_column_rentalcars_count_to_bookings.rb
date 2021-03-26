class AddColumnRentalcarsCountToBookings < ActiveRecord::Migration[6.0]
  class Booking < ApplicationRecord
    has_many :booking_rentalcar_requests
  end

  def change
    add_column :bookings, :rentalcars_count, :integer

    Booking.all.each do |booking|
      booking.update_attribute(:rentalcars_count, booking.booking_rentalcar_requests.count)
    end
  end
end

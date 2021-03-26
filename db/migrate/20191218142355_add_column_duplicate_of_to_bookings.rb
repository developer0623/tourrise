class AddColumnDuplicateOfToBookings < ActiveRecord::Migration[6.0]
  def change
    add_reference :bookings, :duplicate_of, index: true
  end
end

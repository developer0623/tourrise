class AddColumnCanceledAtToBookings < ActiveRecord::Migration[5.2]
  def change
    add_column :bookings, :canceled_at, :datetime
  end
end

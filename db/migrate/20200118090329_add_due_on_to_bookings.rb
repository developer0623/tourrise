class AddDueOnToBookings < ActiveRecord::Migration[6.0]
  def change
    add_column :bookings, :due_on, :date
  end
end

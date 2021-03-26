class AddSecondaryStateToBookings < ActiveRecord::Migration[6.0]
  def change
    add_column :bookings, :secondary_state, :string
  end
end

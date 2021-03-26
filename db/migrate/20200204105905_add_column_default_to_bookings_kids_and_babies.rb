class AddColumnDefaultToBookingsKidsAndBabies < ActiveRecord::Migration[6.0]
  def up
    change_column :bookings, :babies, :integer, default: 0, null: false
  end

  def down
    change_column :bookings, :babies, :integer, default: 0
  end
end

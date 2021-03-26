class AddColumnWishyouwhatToBookings < ActiveRecord::Migration[6.0]
  def change
    add_column :bookings, :wishyouwhat, :text
  end
end

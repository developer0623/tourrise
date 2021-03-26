class AddColumnsTosPpToBookings < ActiveRecord::Migration[6.0]
  def change
    add_column :bookings, :terms_of_service_accepted, :boolean, default: false
    add_column :bookings, :privacy_policy_accepted, :boolean, default: false
  end
end

class AddReferenceEmployeeToBookings < ActiveRecord::Migration[5.2]
  def change
    add_reference :bookings, :assignee
  end
end

# frozen_string_literal: true

class AddFieldsToBookings < ActiveRecord::Migration[5.2]
  def change
    add_column :bookings, :starts_at, :datetime
    add_column :bookings, :ends_at, :datetime

    add_column :bookings, :adults, :integer, null: false, default: 1
    add_column :bookings, :kids, :integer, null: false, default: 0
  end
end

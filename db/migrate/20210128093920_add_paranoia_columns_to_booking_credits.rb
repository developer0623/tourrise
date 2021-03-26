class AddParanoiaColumnsToBookingCredits < ActiveRecord::Migration[6.0]
  def change
    add_column :booking_credits, :deleted_at, :datetime

    add_index :booking_credits, :deleted_at
  end
end

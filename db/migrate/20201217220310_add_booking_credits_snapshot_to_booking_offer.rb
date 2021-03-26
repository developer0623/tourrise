class AddBookingCreditsSnapshotToBookingOffer < ActiveRecord::Migration[6.0]
  def change
    add_column :booking_offers, :booking_credits_snapshot, :text
  end
end

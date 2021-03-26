class AddAcceptedAtAndRejectedAtToBookingOffer < ActiveRecord::Migration[6.0]
  def change
    add_column :booking_offers, :accepted_at, :datetime
    add_column :booking_offers, :rejected_at, :datetime
  end
end

class AddBookingCreditsSnapshotToExistingBookingOffers < ActiveRecord::Migration[6.0]
  def up
    BookingOffer.all.each do |booking_offer|
      credits_update = []
      booking_offer.booking.booking_credits.each do |credit|
        credits_update << credit if credit.created_at < booking_offer.created_at
      end

      booking_offer.update_attribute(:booking_credits_snapshot, credits_update)
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

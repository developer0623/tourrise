class AddBookingCreditsSnapshotToExistingBookingInvoices < ActiveRecord::Migration[6.0]
  def up
    BookingInvoice.all.each do |booking_invoice|
      credits_update = []
      booking_invoice.booking.booking_credits.each do |credit|
        credits_update << credit if credit.created_at < booking_invoice.created_at
      end

      booking_invoice.update_attribute(:booking_credits_snapshot, credits_update)
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

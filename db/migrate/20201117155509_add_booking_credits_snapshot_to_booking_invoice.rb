class AddBookingCreditsSnapshotToBookingInvoice < ActiveRecord::Migration[6.0]
  def change
    add_column :booking_invoices, :booking_credits_snapshot, :text
  end
end

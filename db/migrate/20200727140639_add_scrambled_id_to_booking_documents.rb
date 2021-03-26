class AddScrambledIdToBookingDocuments < ActiveRecord::Migration[6.0]
  def change
    add_column :booking_offers, :scrambled_id, :string
    add_column :booking_invoices, :scrambled_id, :string
  end
end

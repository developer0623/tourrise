class AddBookingResourceSkuSnapshotToBookingOffersAndBookingInvoices < ActiveRecord::Migration[6.0]
  def change
    add_column :booking_offers, :booking_resource_skus_snapshot, :text
    add_column :booking_invoices, :booking_resource_skus_snapshot, :text

    BookingOffer.all.each do |booking_offer|
      booking_offer.update_attribute(:booking_resource_skus_snapshot, booking_offer.booking.booking_resource_skus)
    end

    BookingInvoice.all.each do |booking_invoice|
      booking_invoice.update_attribute(:booking_resource_skus_snapshot, booking_invoice.booking.booking_resource_skus)
    end
  end
end

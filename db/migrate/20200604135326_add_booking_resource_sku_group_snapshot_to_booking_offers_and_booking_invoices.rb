class AddBookingResourceSkuGroupSnapshotToBookingOffersAndBookingInvoices < ActiveRecord::Migration[6.0]
  def change
    add_column :booking_offers, :booking_resource_sku_groups_snapshot, :text
    add_column :booking_invoices, :booking_resource_sku_groups_snapshot, :text

    BookingOffer.all.each do |booking_offer|
      booking_offer.update_attribute(:booking_resource_sku_groups_snapshot, booking_offer.booking.booking_resource_sku_groups)
    end

    BookingInvoice.all.each do |booking_invoice|
      booking_invoice.update_attribute(:booking_resource_sku_groups_snapshot, booking_invoice.booking.booking_resource_sku_groups)
    end
  end
end

class AddPartialInvoiceAndDescriptionToBookingInvoice < ActiveRecord::Migration[6.0]
  def change
    add_column :booking_invoices, :partial_invoice, :boolean, default: false
    add_column :booking_invoices, :description, :text
  end
end

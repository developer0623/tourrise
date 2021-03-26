class CreateAdvanceInvoices < ActiveRecord::Migration[6.0]
  def change
    add_column :booking_invoices, :type, :string, default: 'BookingInvoice'

    remove_column :booking_invoices, :partial_invoice, :boolean, default: false
  end
end

class AddTypeToExistingBookingInvoices < ActiveRecord::Migration[6.0]
  def up
    BookingInvoice.all.each do |invoice|
      next if invoice.type.present?

      invoice.update(type: 'BookingInvoice')
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

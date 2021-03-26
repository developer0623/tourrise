class AddExternalNumberToEasybillInvoices < ActiveRecord::Migration[6.0]
  def change
    add_column :easybill_invoices, :external_number, :string
  end
end

class AddColumnCanceldAtToEasybillInvoice < ActiveRecord::Migration[5.2]
  def change
    add_column :easybill_invoices, :canceled_at, :datetime
  end
end


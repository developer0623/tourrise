class CreateEasybillInvoices < ActiveRecord::Migration[5.2]
  def change
    create_table :easybill_invoices do |t|
      t.references :booking_invoice

      t.string :external_id, null: false, unique: true

      t.timestamps
    end
  end
end

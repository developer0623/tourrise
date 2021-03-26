class CreateBookingResourceSkuCustomers < ActiveRecord::Migration[6.0]
  def change
    create_table :booking_resource_sku_customers do |t|
      t.references :booking_resource_sku, index: { name: 'idx_sku_customers_on_sku_id' }
      t.references :customer, index: { name: 'idx_sku_customers_on_participant_id' }

      t.timestamps
    end
  end
end

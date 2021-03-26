class CreateBookingResourceSkuAvailabilities < ActiveRecord::Migration[6.0]
  def change
    create_table :booking_resource_sku_availabilities do |t|
      t.belongs_to :booking_resource_sku, index: { name: 'idx_b_resource_sku_availabilities_on_b_resource_sku_id' }
      t.belongs_to :availability

      t.belongs_to :blocked_by
      t.datetime :blocked_at

      t.timestamps
    end
  end
end

class CreateBookingOffers < ActiveRecord::Migration[5.2]
  def change
    create_table :booking_offers do |t|
      t.references :booking, index: true

      t.text :booking_snapshot
      t.text :customer_snapshot

      t.text :product_sku_snapshot
      t.text :resource_skus_snapshot

      t.timestamps
    end
  end
end

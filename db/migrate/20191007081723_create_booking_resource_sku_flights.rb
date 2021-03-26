class CreateBookingResourceSkuFlights < ActiveRecord::Migration[6.0]
  def change
    create_table :booking_resource_sku_flights do |t|
      t.references :booking_resource_sku
      t.references :flight

      t.timestamps
    end
  end
end

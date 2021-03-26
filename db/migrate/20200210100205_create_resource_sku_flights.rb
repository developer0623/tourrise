class CreateResourceSkuFlights < ActiveRecord::Migration[6.0]
  def change
    create_table :resource_sku_flights do |t|
      t.references :flight
      t.references :resource_sku

      t.timestamps
    end
  end
end

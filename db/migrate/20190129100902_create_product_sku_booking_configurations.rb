class CreateProductSkuBookingConfigurations < ActiveRecord::Migration[5.2]
  def change
    remove_column :product_skus, :stock, :max_bookings

    create_table :product_sku_booking_configurations do |t|
      t.references :product_sku

      t.integer :max_bookings

      t.datetime :starts_at
      t.datetime :ends_at

      t.timestamps
    end
  end
end

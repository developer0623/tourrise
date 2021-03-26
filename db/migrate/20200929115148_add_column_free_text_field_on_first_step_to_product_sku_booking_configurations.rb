class AddColumnFreeTextFieldOnFirstStepToProductSkuBookingConfigurations < ActiveRecord::Migration[6.0]
  def change
    add_column :product_sku_booking_configurations, :wishyouwhat_on_first_step, :boolean, default: false
  end
end

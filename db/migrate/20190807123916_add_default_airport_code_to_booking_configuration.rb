class AddDefaultAirportCodeToBookingConfiguration < ActiveRecord::Migration[6.0]
  def change
    add_column :product_sku_booking_configurations, :default_destination_airport_code, :string
  end
end

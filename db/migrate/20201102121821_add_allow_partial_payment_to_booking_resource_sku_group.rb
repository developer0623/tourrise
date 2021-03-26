class AddAllowPartialPaymentToBookingResourceSkuGroup < ActiveRecord::Migration[6.0]
  def change
    add_column :booking_resource_sku_groups, :allow_partial_payment, :boolean, default: true
  end
end

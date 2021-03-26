class AddAllowPartialPaymentToResourceSkuAndBookingResourceSku < ActiveRecord::Migration[6.0]
  def change
    add_column :resource_skus, :allow_partial_payment, :boolean, default: true
    add_column :booking_resource_skus, :allow_partial_payment, :boolean, default: true
  end
end

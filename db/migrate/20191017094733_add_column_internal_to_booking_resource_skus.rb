class AddColumnInternalToBookingResourceSkus < ActiveRecord::Migration[6.0]
  def change
    add_column :booking_resource_skus, :internal, :boolean, default: false
  end
end

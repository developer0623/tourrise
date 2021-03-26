class AddResourceSkuSnapshotToBookingResourceSkus < ActiveRecord::Migration[6.0]
  def up
    add_column :booking_resource_skus, :resource_sku_snapshot, :text
    add_column :booking_resource_skus, :resource_snapshot, :text

    BookingResourceSku.unscoped.all.each do |booking_resource_sku|
      booking_resource_sku.send(:memoize_resource_sku_details)
      booking_resource_sku.save
    end
  end

  def down
    remove_column :booking_resource_skus, :resource_sku_snapshot, :text
    remove_column :booking_resource_skus, :resource_snapshot, :text
  end
end

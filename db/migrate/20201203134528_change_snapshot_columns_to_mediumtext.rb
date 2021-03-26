class ChangeSnapshotColumnsToMediumtext < ActiveRecord::Migration[6.0]
  def change
    change_column :booking_offers, :booking_resource_skus_snapshot, :mediumtext
    change_column :booking_offers, :booking_resource_sku_groups_snapshot, :mediumtext
    change_column :booking_invoices, :booking_resource_skus_snapshot, :mediumtext
    change_column :booking_invoices, :booking_resource_sku_groups_snapshot, :mediumtext
  end
end

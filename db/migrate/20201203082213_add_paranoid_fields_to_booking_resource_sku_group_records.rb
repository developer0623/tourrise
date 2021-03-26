class AddParanoidFieldsToBookingResourceSkuGroupRecords < ActiveRecord::Migration[6.0]
  def change
    add_column :booking_resource_sku_groups, :deleted_at, :datetime

    add_index :booking_resource_sku_groups, :deleted_at

    add_index :booking_resource_sku_groups_skus, :booking_resource_sku_group_id, name: 'not_d_idx_bkng_rsrc_sku_grps_skus_on_bkng_rsrc_sku_grps_id', where: "deleted_at IS NULL"
  end
end

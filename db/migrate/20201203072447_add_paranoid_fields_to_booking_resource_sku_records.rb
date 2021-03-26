class AddParanoidFieldsToBookingResourceSkuRecords < ActiveRecord::Migration[6.0]
  def change
    add_column :booking_resource_skus, :deleted_at, :datetime
    add_column :booking_attribute_values, :deleted_at, :datetime
    add_column :booking_resource_sku_flights, :deleted_at, :datetime
    add_column :booking_resource_sku_customers, :deleted_at, :datetime

    add_index :booking_resource_skus, :deleted_at
    add_index :booking_attribute_values, :deleted_at
    add_index :booking_resource_sku_flights, :deleted_at
    add_index :booking_resource_sku_customers, :deleted_at

    add_index :booking_attribute_values, :booking_resource_sku_id, name: 'not_d_indx_booking_attribute_values_on_b_rsc_sku_id', where: "deleted_at IS NULL"
    add_index :booking_attribute_values, [:booking_resource_sku_id, :handle], name: 'not_d_idx_b_attr_vals_on_b_res_sku_id_hndl', where: "deleted_at IS NULL"
    add_index :booking_resource_sku_availabilities, :booking_resource_sku_id, name: 'not_d_idx_b_rsc_sku_avlbilts_on_b_rsc_sku_id', where: "deleted_at IS NULL"
    add_index :booking_resource_sku_customers, :booking_resource_sku_id, name: 'not_d_idx_sku_cus_on_sku_id', where: "deleted_at IS NULL"
    add_index :booking_resource_sku_flights, :booking_resource_sku_id, name: 'not_d_index_b_res_sku_flights_on_b_rsc_sku_id', where: "deleted_at IS NULL"
    add_index :booking_resource_sku_groups_skus, :booking_resource_sku_id, name: 'not_d_idx_bkng_rsrc_sku_grps_skus_on_bkng_rsrc_sku_id', where: "deleted_at IS NULL"
    add_index :booking_resource_sku_participants, :booking_resource_sku_id, name: 'not_d_idx_sku_ptcts_on_sku_id', where: "deleted_at IS NULL"
  end
end

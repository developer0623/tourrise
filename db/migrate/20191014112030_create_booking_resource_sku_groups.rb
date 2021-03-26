class CreateBookingResourceSkuGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :booking_resource_sku_groups do |t|
      t.belongs_to :booking

      t.string :name, null: false
      t.monetize :price

      t.timestamps
    end

    create_table :booking_resource_sku_groups_skus, id: false do |t|
      t.belongs_to :booking_resource_sku_group, index: { name: :idx_bkng_rsrc_sku_grps_skus_on_bkng_rsrc_sku_grp_id }
      t.belongs_to :booking_resource_sku, index: { name: :idx_bkng_rsrc_sku_grps_skus_on_bkng_rsrc_sku_id }
    end
  end
end

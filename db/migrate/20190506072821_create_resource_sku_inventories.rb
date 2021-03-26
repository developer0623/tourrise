class CreateResourceSkuInventories < ActiveRecord::Migration[5.2]
  def change
    create_table :resource_sku_inventories do |t|
      t.references :resource_sku
      t.references :inventory
    end

    add_index :resource_sku_inventories,
      %i[resource_sku_id inventory_id],
      unique: true,
      name: 'idx_sku_inventories_on_sku_id_and_inventory_id'

    drop_table :resource_sku_availabilities
  end
end

class CreateAvailabilities < ActiveRecord::Migration[5.2]
  def change
    create_table :availabilities do |t|
      t.string :availability_type, default: :quantity
      t.integer :quantity

      t.timestamps
    end

    create_table :resource_sku_availabilities do |t|
      t.references :resource_sku
      t.references :availability
    end

    add_index :resource_sku_availabilities, [:resource_sku_id, :availability_id], unique: true, name: 'idx_sku_availabilities_on_sku_id_and_avail_id'
  end
end

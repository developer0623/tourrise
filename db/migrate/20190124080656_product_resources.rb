class ProductResources < ActiveRecord::Migration[5.2]
  def change
    create_table :product_resources do |t|
      t.references :resource, index: true
      t.references :product, index: true
    end

    add_index :product_resources, %i[resource_id product_id], unique: true
  end
end

class AddColumnMinQuantityToResourceSkuPricings < ActiveRecord::Migration[5.2]
  def change
    add_column :resource_sku_pricings, :min_quantity, :integer
  end
end

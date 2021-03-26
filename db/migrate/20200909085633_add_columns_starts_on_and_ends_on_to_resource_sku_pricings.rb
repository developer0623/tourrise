class AddColumnsStartsOnAndEndsOnToResourceSkuPricings < ActiveRecord::Migration[6.0]
  def change
    add_column :resource_sku_pricings, :starts_on, :date
    add_column :resource_sku_pricings, :ends_on, :date
  end
end

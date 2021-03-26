class AddResourceSkuPricingToConsecutiveDaysRanges < ActiveRecord::Migration[6.0]
  def change
    add_reference :consecutive_days_ranges, :resource_sku_pricing, null: false, foreign_key: true

    remove_index :consecutive_days_ranges, :resource_sku_id
    remove_column :consecutive_days_ranges, :resource_sku_id
  end
end

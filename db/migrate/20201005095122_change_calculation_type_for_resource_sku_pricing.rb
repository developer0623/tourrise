class ChangeCalculationTypeForResourceSkuPricing < ActiveRecord::Migration[6.0]
  def change
    rename_column :resource_sku_pricings, :calculation_type, :calculation_type_old

    add_column :resource_sku_pricings, :calculation_type, :integer, default: 0, null: false
    add_index :resource_sku_pricings, :calculation_type

    populate_new_calculation_type_with_old_values

    remove_column :resource_sku_pricings, :calculation_type_old
  end

  private

  def populate_new_calculation_type_with_old_values
    ResourceSkuPricing.all.each do |sp|
      sp.update_attribute(:calculation_type, sp.calculation_type_old)
    end
  end
end

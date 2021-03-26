class ChangeProductVariants < ActiveRecord::Migration[5.2]
  def change
    rename_column :product_variants, :sku_id, :product_sku_id
    rename_column :product_variants, :option_id, :product_option_id
    rename_column :product_variants, :option_value_id, :product_option_value_id
  end
end

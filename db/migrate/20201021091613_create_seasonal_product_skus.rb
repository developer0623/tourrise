class CreateSeasonalProductSkus < ActiveRecord::Migration[6.0]
  def change
    create_table :seasonal_product_skus do |t|
      t.references :product_sku
      t.references :season

      t.date :starts_on
      t.date :ends_on

      t.timestamps
    end
  end
end

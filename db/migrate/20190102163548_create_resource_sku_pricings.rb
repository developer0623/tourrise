# frozen_string_literal: true

class CreateResourceSkuPricings < ActiveRecord::Migration[5.2]
  def change
    create_table :resource_sku_pricings do |t|
      t.references :resource_sku
      t.monetize :price
      t.string :calculation_type, null: false, default: :fixed

      t.timestamps
    end
  end
end

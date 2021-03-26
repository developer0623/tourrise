# frozen_string_literal: true

class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.datetime :published_at
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :products, :deleted_at

    create_table :product_custom_attributes do |t|
      t.references :product, index: true

      t.string :name
      t.text   :value

      t.datetime :deleted_at

      t.timestamps
    end

    add_index :product_custom_attributes, :deleted_at

    create_table :product_options do |t|
      t.references :product, index: true

      t.string :name

      t.datetime :deleted_at

      t.timestamps
    end

    add_index :product_options, :deleted_at

    create_table :product_option_values do |t|
      t.references :option, index: true

      t.string :value

      t.datetime :deleted_at

      t.timestamps
    end

    add_index :product_option_values, :deleted_at

    create_table :product_skus do |t|
      t.monetize :price

      t.references :product, index: true

      t.string :name
      t.text :barcode
      t.integer :stock, default: 0, null: false

      t.datetime :deleted_at

      t.timestamps
    end

    add_index :product_skus, :deleted_at

    create_table :product_variants do |t|
      t.references :product, index: true
      t.references :sku
      t.references :option
      t.references :option_value
    end

    add_index :product_variants, %i[sku_id option_id], unique: true

    add_index :product_variants, %i[product_id sku_id]
    add_index :product_variants, %i[product_id option_id]
    add_index :product_variants, %i[sku_id option_id option_value_id], name: 'index_sku_option_and_option_value_ids', unique: true
  end
end

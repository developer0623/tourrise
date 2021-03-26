# frozen_string_literal: true

class CreateResources < ActiveRecord::Migration[5.2]
  def change
    create_table :resources do |t|
      t.string :name
      t.text :description

      t.timestamps
    end

    create_table :resource_options do |t|
      t.references :resource, index: true

      t.string :name

      t.timestamps
    end

    create_table :resource_option_values do |t|
      t.references :resource_option, index: true

      t.string :value

      t.timestamps
    end

    create_table :resource_skus do |t|
      t.references :resource, index: true

      t.string :name
      t.string :handle

      t.timestamps
    end

    create_table :resource_variants do |t|
      t.references :resource, index: true
      t.references :resource_sku
      t.references :resource_option
      t.references :resource_option_value
    end

    add_index :resource_variants, %i[resource_sku_id resource_option_id], name: 'index_sku_id_and_option_id', unique: true
    add_index :resource_variants, %i[resource_id resource_sku_id], name: 'index_resource_id_and_sku_id'
    add_index :resource_variants, %i[resource_id resource_option_id], name: 'index_resource_id_and_option_id'
    add_index :resource_variants, %i[resource_sku_id resource_option_id resource_option_value_id], name: 'index_sku_option_and_option_value_ids', unique: true
  end
end

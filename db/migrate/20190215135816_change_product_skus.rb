class ChangeProductSkus < ActiveRecord::Migration[5.2]
  class ProductSku < ApplicationRecord
    validates :name, :handle, presence: true

    def generate_handle
      name.parameterize
    end
  end

  def up
    remove_monetize :product_skus, :price

    add_column :product_skus, :handle, :string, null: false, index: true

    ProductSku.all.each do |sku|
      sku.update(handle: sku.generate_handle)
    end
  end

  def down
    add_monetize :product_skus, :price_cents

    remove_column :product_skus, :handle, :string, null: false, index: true
  end
end

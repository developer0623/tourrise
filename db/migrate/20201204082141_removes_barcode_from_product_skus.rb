class RemovesBarcodeFromProductSkus < ActiveRecord::Migration[6.0]
  def change
    remove_column :product_skus, :barcode, :text
  end
end

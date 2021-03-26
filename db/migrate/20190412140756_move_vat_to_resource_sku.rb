class MoveVatToResourceSku < ActiveRecord::Migration[5.2]
  def change
    add_column :resource_skus,
      :vat,
      :decimal,
      precision: 5,
      scale: 2,
      null: false,
      default: 0.00
    add_column :resource_skus, :finac_account, :string
    add_monetize :resource_sku_pricings,
      :purchase_price

    remove_column :booking_resource_skus, :vat, :decimal, precision: 5, scale: 2, null: false, default: 0.00
  end
end

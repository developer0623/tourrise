class AddColumnParticipantTypeToResourceSkuPricings < ActiveRecord::Migration[6.0]
  def change
    add_column :resource_sku_pricings, :participant_type, :integer, default: 0, null: false
    add_index :resource_sku_pricings, :participant_type
  end
end

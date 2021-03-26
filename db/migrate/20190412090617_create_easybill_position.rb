class CreateEasybillPosition < ActiveRecord::Migration[5.2]
  def change
    create_table :easybill_positions do |t|
      t.string :external_id, null: false, uniq: true

      t.references :position_group, index: true
      t.references :resource_sku, index: true

      t.timestamps
    end
  end
end

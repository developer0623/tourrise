class CreateEasybillPositionGroup < ActiveRecord::Migration[5.2]
  def change
    create_table :easybill_position_groups do |t|
      t.string :external_id, null: false

      t.references :resource, index: true, unique: true

      t.timestamps
    end
  end
end

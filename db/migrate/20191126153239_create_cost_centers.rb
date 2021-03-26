class CreateCostCenters < ActiveRecord::Migration[6.0]
  def change
    create_table :cost_centers do |t|
      t.string :name
      t.string :value

      t.timestamps
    end
  end
end

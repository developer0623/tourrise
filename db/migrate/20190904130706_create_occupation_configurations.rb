class CreateOccupationConfigurations < ActiveRecord::Migration[6.0]
  def change
    create_table :occupation_configurations do |t|
      t.string :name

      t.integer :min_occupancy
      t.integer :max_occupancy

      t.integer :min_adults
      t.integer :max_adults

      t.integer :min_kids, default: 0
      t.integer :max_kids, default: 0

      t.integer :min_babies, default: 0
      t.integer :max_babies, default: 0

      t.timestamps
    end
  end
end

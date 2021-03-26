class CreateInventories < ActiveRecord::Migration[5.2]
  def change
    create_table :inventories do |t|
      t.string :name
      t.text :description

      t.timestamps
    end

    add_reference :availabilities, :inventory, index: true
  end
end

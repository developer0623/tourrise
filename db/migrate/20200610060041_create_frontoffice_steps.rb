class CreateFrontofficeSteps < ActiveRecord::Migration[6.0]
  def change
    create_table :frontoffice_steps do |t|
      t.string :name
      t.string :handle
      t.string :description
      t.integer :position
      t.timestamps
    end
  end
end

class CreateCustomAttributes < ActiveRecord::Migration[6.0]
  def change
    create_table :custom_attributes do |t|
      t.string :handle
      t.integer :field_type, default: 0, null: false
      t.timestamps
    end
  end
end

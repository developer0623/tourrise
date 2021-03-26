class CreateCustomAttributeValues < ActiveRecord::Migration[6.0]
  def change
    create_table :custom_attribute_values do |t|
      t.belongs_to :custom_attribute
      t.belongs_to :attributable, polymorphic: true, index: { name: :custom_attribute_id_value_id }
      t.text :value
      t.timestamps
    end
  end
end

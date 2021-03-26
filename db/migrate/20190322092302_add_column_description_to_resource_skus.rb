class AddColumnDescriptionToResourceSkus < ActiveRecord::Migration[5.2]
  def change
    add_column :resource_skus, :description, :string
  end
end

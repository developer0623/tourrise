class AddColumnPositionToProductResources < ActiveRecord::Migration[5.2]
  def change
    add_column :product_resources, :position, :integer
  end
end

class AddColumnAvailableToResourceSkus < ActiveRecord::Migration[5.2]
  def change
    add_column :resource_skus, :available, :boolean, null: false, default: true
    add_column :resource_skus, :cost_center, :string
  end
end

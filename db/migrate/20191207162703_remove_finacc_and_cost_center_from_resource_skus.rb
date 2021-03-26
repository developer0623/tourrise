class RemoveFinaccAndCostCenterFromResourceSkus < ActiveRecord::Migration[6.0]
  def change
    remove_column :resource_skus, :finac_account, :string
    remove_column :resource_skus, :cost_center, :string
  end
end

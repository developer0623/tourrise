class AddFinancialAccountAndCostCenterReferenceToProductSku < ActiveRecord::Migration[6.0]
  def change
    add_reference :product_skus, :financial_account, foreign_key: true
    add_reference :product_skus, :cost_center, foreign_key: true
  end
end

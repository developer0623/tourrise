class AddFinancialAccountAndToProducts < ActiveRecord::Migration[6.0]
  def change
    add_reference :products, :financial_account, foreign_key: true
    add_reference :products, :cost_center, foreign_key: true
  end
end

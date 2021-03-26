class AddFinancialAccountAndCostCenterToBookingResourceSkuGroups < ActiveRecord::Migration[6.0]
  def change
    add_reference :booking_resource_sku_groups, :financial_account, foreign_key: true
    add_reference :booking_resource_sku_groups, :cost_center, foreign_key: true
  end
end

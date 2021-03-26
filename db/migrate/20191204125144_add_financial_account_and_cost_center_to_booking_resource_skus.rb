class AddFinancialAccountAndCostCenterToBookingResourceSkus < ActiveRecord::Migration[6.0]
  def change
    add_reference :booking_resource_skus, :financial_account, foreign_key: true
    add_reference :booking_resource_skus, :cost_center, foreign_key: true
  end
end

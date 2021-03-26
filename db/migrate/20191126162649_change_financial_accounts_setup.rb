class ChangeFinancialAccountsSetup < ActiveRecord::Migration[6.0]
  def change
    remove_column :financial_accounts, :value, :string

    add_column :financial_accounts, :before_service_year, :string
    add_column :financial_accounts, :during_service_year, :string
  end
end

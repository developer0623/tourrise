class CreateFinancialAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :financial_accounts do |t|
      t.string :name
      t.string :value

      t.timestamps
    end
  end
end

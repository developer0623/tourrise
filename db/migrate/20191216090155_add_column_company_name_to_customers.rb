class AddColumnCompanyNameToCustomers < ActiveRecord::Migration[6.0]
  def change
    add_column :customers, :company_name, :string
  end
end

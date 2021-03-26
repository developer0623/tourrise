class AddGeneralCustomerIdToCustomers < ActiveRecord::Migration[6.0]
  def change
    add_column :customers, :general_customer_id, :integer, index: true, unique: true
  end
end

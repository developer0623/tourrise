class AddPlaceholderToCustomers < ActiveRecord::Migration[6.0]
  def change
    add_column :customers, :placeholder, :boolean, default: false
  end
end

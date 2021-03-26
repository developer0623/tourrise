class AddLocaleToCustomers < ActiveRecord::Migration[6.0]
  def change
    add_column :customers, :locale, :string, default: 'de'
  end
end

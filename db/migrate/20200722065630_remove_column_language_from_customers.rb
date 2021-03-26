class RemoveColumnLanguageFromCustomers < ActiveRecord::Migration[6.0]
  def change
    remove_column :customers, :language
  end
end

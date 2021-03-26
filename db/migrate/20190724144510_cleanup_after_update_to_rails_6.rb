class CleanupAfterUpdateToRails6 < ActiveRecord::Migration[6.0]
  remove_index :customers, :deleted_at
  remove_column :customers, :deleted_at

  remove_index :products, :deleted_at
  remove_index :product_custom_attributes, :deleted_at
  remove_index :product_options, :deleted_at
  remove_index :product_option_values, :deleted_at
  remove_index :product_skus, :deleted_at

  drop_table :active_admin_comments
  drop_table :sessions
end

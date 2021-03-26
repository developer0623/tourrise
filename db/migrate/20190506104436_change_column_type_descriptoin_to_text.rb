class ChangeColumnTypeDescriptoinToText < ActiveRecord::Migration[5.2]
  def change
    change_column :resource_skus, :description, :text
  end
end

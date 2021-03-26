class AddColumnHandleToResources < ActiveRecord::Migration[6.0]
  def change
    add_column :resources, :handle, :string, index: true
  end
end

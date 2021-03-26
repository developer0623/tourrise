class AddUniquenessConstraintOnResourceSkuHandle < ActiveRecord::Migration[5.2]
  def change
    add_index :resource_skus, :handle, unique: true
  end
end

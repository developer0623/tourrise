class MoveAvailabilityTypeToInventoryType < ActiveRecord::Migration[6.0]
  class Inventory < ApplicationRecord
    has_many :availabilities
  end

  class Availability < ApplicationRecord
    belongs_to :inventory
  end

  def up
    add_column :inventories, :inventory_type, :string, null: false, index: true

    Inventory.all.each do |inventory|
      inventory_type = inventory.availabilities.pluck(:availability_type)&.first
      inventory.update_attribute(:inventory_type, inventory_type || :quantity)
    end

    remove_column :availabilities, :availability_type, :string
  end

  def down
    add_column :availabilities, :availability_type, :string

    Inventory.all.each do |inventory|
      inventory_type = inventory.inventory_type
      inventory.availabilities.update_all(availability_type: inventory_type)
    end

    remove_column :inventories, :inventory_type, :string, null: false, index: true
  end
end

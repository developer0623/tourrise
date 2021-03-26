class CreateResourceTypes < ActiveRecord::Migration[5.2]
  class ResourceType < ApplicationRecord; end
  class Resource < ApplicationRecord
    belongs_to :resource_type
  end

  def up
    create_table :resource_types do |t|
      t.string :label, null: false
      t.string :handle, null: false, index: true
    end

    add_reference :resources, :resource_type
  end

  def down
    drop_table :resource_types
    remove_reference :resources, :resource_type
  end
end

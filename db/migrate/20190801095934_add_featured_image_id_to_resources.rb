class AddFeaturedImageIdToResources < ActiveRecord::Migration[6.0]
  def change
    add_column :resources, :featured_image_id, :integer, index: true
  end
end

class AddTeaserTextToResourceAndSkus < ActiveRecord::Migration[5.2]
  def change
    add_column :resources, :teaser_text, :text
    add_column :resource_skus, :teaser_text, :text
  end
end

class CreateTaggables < ActiveRecord::Migration[6.0]
  def change
    create_table :taggables do |t|
      t.belongs_to :taggable, index: true, polymorphic: true

      t.belongs_to :tag
    end
  end
end

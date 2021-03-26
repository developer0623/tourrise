class CreateTags < ActiveRecord::Migration[6.0]
  class Tag < ApplicationRecord
    translates :name
  end

  def change
    create_table :tags do |t|
      t.string :handle, unique: true, index: true
      t.timestamps
    end

    reversible do |dir|
      dir.up do
        Tag.create_translation_table!(name: :string)
      end

      dir.down do
        Tag.drop_translation_table!
      end
    end
  end
end

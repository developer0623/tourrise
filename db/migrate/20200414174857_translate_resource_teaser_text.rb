class TranslateResourceTeaserText < ActiveRecord::Migration[6.0]
  def change
    reversible do |dir|
      dir.up do
        Resource.add_translation_fields!({ teaser_text: :text }, { migrate_data: true, remove_source_columns: true })
      end

      dir.down do
        remove_column :resource_translations, :teaser_text
      end
    end
  end
end


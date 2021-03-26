class TranslateResouceSkus < ActiveRecord::Migration[6.0]
  def up
    I18n.with_locale(:de) do
      ResourceSku.create_translation_table!(
          { name: :string, description: :text },
          { migrate_data: true, remove_source_columns: true }
      )
    end
  end

  def down
    add_column :resource_skus, :name, :string
    add_column :resource_skus, :description, :text
    ResourceSku.drop_translation_table! migrate_data:  true
  end
end

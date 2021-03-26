class TranslateResouces < ActiveRecord::Migration[6.0]
  def up
    I18n.with_locale(:de) do
      Resource.create_translation_table!(
          { name: :string, description: :text },
          { migrate_data: true, remove_source_columns: true }
      )
    end
  end

  def down
    add_column :resources, :name, :string
    add_column :resources, :description, :text
    Resource.drop_translation_table! migrate_data:  true
  end
end

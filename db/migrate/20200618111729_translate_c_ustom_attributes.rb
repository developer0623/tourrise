class TranslateCUstomAttributes < ActiveRecord::Migration[6.0]
  def up
    I18n.with_locale(:de) do
      CustomAttribute.create_translation_table!(
          { name: :string },
          { migrate_data: true, remove_source_columns: true }
      )
    end
  end

  def down
    add_column :custom_attributes, :name, :string
    CustomAttribute.drop_translation_table! migrate_data:  true
  end
end

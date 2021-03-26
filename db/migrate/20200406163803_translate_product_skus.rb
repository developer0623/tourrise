class TranslateProductSkus < ActiveRecord::Migration[6.0]
  def up
    I18n.with_locale(:de) do
      ProductSku.create_translation_table!(
          { name: :string, description: :text },
          { migrate_data: true, remove_source_columns: true }
      )
    end
  end

  def down
    add_column :product_skus, :name, :string
    add_column :product_skus, :description, :text
    ProductSku.drop_translation_table! migrate_data:  true
  end
end

class TranslateProductConfigurations < ActiveRecord::Migration[6.0]
  def up
    I18n.with_locale(:de) do
      Easybill::ProductConfiguration.create_translation_table!(
          { invoice_template: :text, offer_template: :text },
          { migrate_data: true, remove_source_columns: true }
      )
    end
  end

  def down
    add_column :products, :invoice_template, :text
    add_column :products, :offer_template, :text
    Easybill::ProductConfiguration.drop_translation_table! migrate_data:  true
  end
end

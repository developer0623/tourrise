class UpdateDocumentReferencesPrice < ActiveRecord::Migration[6.0]
  def up
    DocumentReference.connection.schema_cache.clear!
    DocumentReference.reset_column_information

    DataMigrations::UpdateAddedDocumentReferencesTotalPrice.call!
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

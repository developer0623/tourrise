class AddEventToDocumentReferences < ActiveRecord::Migration[6.0]
  def up
    DocumentReference.connection.schema_cache.clear!
    DocumentReference.reset_column_information

    DocumentReference.all.update_all(event: 0)
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

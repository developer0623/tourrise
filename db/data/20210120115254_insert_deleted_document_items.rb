class InsertDeletedDocumentItems < ActiveRecord::Migration[6.0]
  def up
    DataMigrations::InsertDeletedDocumentItems.call!
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

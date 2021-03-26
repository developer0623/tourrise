class AddColumnEventToDocumentReferences < ActiveRecord::Migration[6.0]
  def change
    add_column :document_references, :event, :integer, null: false, index: true
  end
end

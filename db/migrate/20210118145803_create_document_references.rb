# frozen_string_literal: true

class CreateDocumentReferences < ActiveRecord::Migration[6.0]
  def change
    create_table :document_references do |t|
      t.references :document, polymorphic: true
      t.references :item, polymorphic: true
      t.integer :item_version_id

      t.timestamps
    end
  end
end

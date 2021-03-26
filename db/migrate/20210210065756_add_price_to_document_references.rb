class AddPriceToDocumentReferences < ActiveRecord::Migration[6.0]
  def change
    add_monetize :document_references, :price
  end
end

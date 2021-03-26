class AddExternalDocumentUrlColumnToFrontofficeSettings < ActiveRecord::Migration[6.0]
  def change
    add_column :frontoffice_settings, :external_document_preview_url, :string
  end
end

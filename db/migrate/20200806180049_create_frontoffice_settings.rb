class CreateFrontofficeSettings < ActiveRecord::Migration[6.0]
  def change
    create_table :frontoffice_settings do |t|
      t.timestamps
      t.string :company_name
      t.text :address_line_1
      t.text :address_line_2
      t.string :zip_code
      t.string :city
      t.string :state
      t.string :country
      t.string :phone
      t.string :email
      t.string :vat_id
    end

    reversible do |dir|
      dir.up do
        FrontofficeSetting.create_translation_table!(
          { external_terms_of_service_url: :string,
            external_privacy_policy_url: :string }
        )
      end

      dir.down do
        FrontofficeSetting.drop_translation_table!
      end
    end
  end
end

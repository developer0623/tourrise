class AddExternalNumberToEasybillOffers < ActiveRecord::Migration[6.0]
  def change
    add_column :easybill_offers, :external_number, :string
  end
end

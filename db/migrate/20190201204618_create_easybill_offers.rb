class CreateEasybillOffers < ActiveRecord::Migration[5.2]
  def change
    create_table :easybill_offers do |t|
      t.references :booking_offer

      t.string :external_id, null: false, unique: true

      t.timestamps
    end
  end
end

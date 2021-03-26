class CreateBookingResourceSkuParticipants < ActiveRecord::Migration[6.0]
  def change
    create_table :booking_resource_sku_participants do |t|
      t.references :booking_resource_sku, index: { name: 'idx_sku_participants_on_sku_id' }
      t.references :participant, index: { name: 'idx_sku_participants_on_participant_id' }

      t.timestamps
    end
  end
end

# This migration comes from action_text (originally 20180528164100)
class CreateActionTextTables < ActiveRecord::Migration[6.0]
  def up
    create_table :action_text_rich_texts do |t|
      t.string     :name, null: false
      t.text       :body, size: :long
      t.references :record, null: false, polymorphic: true, index: false

      t.timestamps

      t.index [ :record_type, :record_id, :name ], name: "index_action_text_rich_texts_uniqueness", unique: true
    end

    Booking.where.not(wishyouwhat: nil).each do |booking|
      booking.update_attribute(:wishyouwhat, booking.read_attribute(:wishyouwhat))
    end

    remove_column :bookings, :wishyouwhat, :text
  end

  def down
    add_column :bookings, :wishyouwhat, :text

    Booking.all.with_rich_text_wishyouwhat.each do |booking|
      booking.update_column(:wishyouwhat, booking.wishyouwhat.to_plain_text)
    end

    drop_table :action_text_rich_texts
  end
end

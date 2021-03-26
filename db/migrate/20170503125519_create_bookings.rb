# frozen_string_literal: true

class CreateBookings < ActiveRecord::Migration[5.1]
  def change
    create_table :bookings do |t|
      t.references :product_sku
      t.references :customer
      t.references :creator

      t.string :first_name
      t.string :last_name
      t.string :title
      t.text :address_line_1
      t.text :address_line_2
      t.string :zip
      t.string :city
      t.string :state
      t.string :country
      t.string :company
      t.string :language

      t.string :email
      t.string :phone
      t.string :gender
      t.date :birthdate

      t.timestamps
    end

    create_table :booking_participants do |t|
      t.references :participant
      t.references :booking
    end

    add_index :booking_participants, %i[participant_id booking_id], name: 'index_booking_participants_on_participant_id_and_booking_id', unique: true
  end
end

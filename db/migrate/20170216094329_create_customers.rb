# frozen_string_literal: true

class CreateCustomers < ActiveRecord::Migration[5.0]
  def change
    create_table :customers do |t|
      t.string :title
      t.string :first_name
      t.string :last_name
      t.string :gender
      t.date :birthdate
      t.string :country
      t.string :state
      t.string :zip
      t.text :address_line_1
      t.text :address_line_2
      t.string :city
      t.string :language
      t.string :email
      t.string :primary_phone
      t.string :secondary_phone

      t.datetime :deleted_at

      t.timestamps
    end

    add_index :customers, :deleted_at
  end
end

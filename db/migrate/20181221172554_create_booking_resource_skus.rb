# frozen_string_literal: true

class CreateBookingResourceSkus < ActiveRecord::Migration[5.2]
  def change
    create_table :booking_resource_skus do |t|
      t.references :booking
      t.references :resource_sku
    end
  end
end

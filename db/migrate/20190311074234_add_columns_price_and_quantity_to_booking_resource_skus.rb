class AddColumnsPriceAndQuantityToBookingResourceSkus < ActiveRecord::Migration[5.2]
  class BookingResourceSku < ApplicationRecord
    monetize :price_cents

    belongs_to :booking
    belongs_to :resource_sku

    def pricing
      resource_sku.resource_sku_pricings&.first
    end

    def calculation_type
      pricing&.calculation_type&.to_sym
    end

    def calculate_price
      case calculation_type
      when :fixed
        pricing.price
      when :quantity
        booking.nights * pricing.price
      end
    end

    def calculate_quantity
      case calculation_type
      when :fixed
        1
      when :quantity
        booking.nights
      else
        1
      end
    end
  end

  def up
    add_monetize :booking_resource_skus, :price
    add_column :booking_resource_skus, :quantity, :integer, null: false, default: 1
    add_column :booking_resource_skus, :vat, :decimal, precision: 5, scale: 2, null: false, default: 0.00

    BookingResourceSku.all.each do |booking_resource_sku|
      booking_resource_sku.update(
        price: booking_resource_sku.calculate_price,
        quantity: booking_resource_sku.calculate_quantity,
        vat: 19.00
      )
    end
  end

  def down
    remove_monetize :booking_resource_skus, :price
    remove_column :booking_resource_skus, :quantity, :integer, null: false, default: 1
    remove_column :booking_resource_skus, :vat, :decimal, precision: 5, scale: 2, null: false, default: 0.00
  end
end

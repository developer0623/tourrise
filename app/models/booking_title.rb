# frozen_string_literal: true

class BookingTitle
  def self.from_product_sku(product_sku)
    title = product_sku.product.name
    title += " #{product_sku.name}" if product_sku.product.name != product_sku.name
    title
  end
end

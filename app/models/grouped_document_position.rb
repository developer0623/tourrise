# frozen_string_literal: true

class GroupedDocumentPosition < DocumentPosition
  def quantity
    booking_resource_sku_snapshot["quantity"]
  end

  def price; end

  def total_price; end
end

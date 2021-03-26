# frozen_string_literal: true

class DocumentPosition
  attr_reader :booking_resource_sku_snapshot

  def initialize(booking_resource_sku_snapshot)
    @booking_resource_sku_snapshot = booking_resource_sku_snapshot
  end

  def internal?
    booking_resource_sku_snapshot["internal"]
  end

  def name
    booking_resource_sku_snapshot["resource_sku_snapshot"]["name"]
  end

  def handle
    booking_resource_sku_snapshot["resource_sku_snapshot"]["handle"]
  end

  def description
    return if booking_resource_sku_snapshot["starts_on"].blank? || booking_resource_sku_snapshot["ends_on"].blank?

    starts_on = booking_resource_sku_snapshot["starts_on"].to_date
    ends_on = booking_resource_sku_snapshot["ends_on"].to_date

    { "starts_on" => starts_on, "ends_on" => ends_on }
  end

  def quantity
    booking_resource_sku_snapshot["quantity"]
  end

  def price
    Money.new(booking_resource_sku_snapshot["price_cents"], booking_resource_sku_snapshot["price_currency"])
  end

  def total_price
    quantity * price
  end
end

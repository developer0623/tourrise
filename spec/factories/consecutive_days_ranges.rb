# frozen_string_literal: true

FactoryBot.define do
  factory :consecutive_days_range do
    resource_sku_pricing { ResourceSkuPricing.consecutive_days.last || association(:resource_sku_pricing) }

    price { Money.new(rand(100..10000)) }
    from { 3 }
    to { 7 }
  end
end

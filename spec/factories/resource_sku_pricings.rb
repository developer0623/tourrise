# frozen_string_literal: true

FactoryBot.define do
  factory :resource_sku_pricing do
    resource_sku { ResourceSku.last || association(:resource_sku) }

    price { Money.new(rand(100..10000)) }
    purchase_price { Money.new(rand(100..10000)) }
    min_quantity { nil }
    starts_on { rand(1..1000).days.from_now }
    ends_on { starts_on + rand(1..14).days }
    calculation_type { :fixed }

    traits_for_enum :calculation_type, ResourceSkuPricing.calculation_types.keys
    traits_for_enum :participant_type, ResourceSkuPricing.participant_types.keys
  end
end


# frozen_string_literal: true

FactoryBot.define do
  factory :resource_sku do
    name { Faker::Lorem.word }
    handle { Faker::Lorem.words(2).join('-') }

    resource

    factory :resource_sku_with_pricings do
      transient do
        pricings_count { 2 }
        pricings_traits { [] }
        pricings_options { {} }
      end

      resource_sku_pricings do
        Array.new(pricings_count) do
          association(:resource_sku_pricing, *pricings_traits, **pricings_options)
        end
      end
    end
  end
end


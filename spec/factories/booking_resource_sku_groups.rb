# frozen_string_literal: true

FactoryBot.define do
  factory :booking_resource_sku_group do
    name { Faker::Lorem.sentence }
    price { Money.new(rand(100..10000)) }

    association :booking
    association :financial_account
    association :cost_center

    factory :booking_resource_sku_group_with_booking_resource_skus do
      transient do
        booking_resource_skus_count { 2 }
        booking_resource_skus_options { {} }
      end

      after(:create) do |sku_group, evaluator|
        evaluator.booking_resource_skus_count.times do
          sku_group.booking_resource_skus << create(:booking_resource_sku, **evaluator.booking_resource_skus_options)
        end
      end
    end
  end
end

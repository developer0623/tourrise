# frozen_string_literal: true

FactoryBot.define do
  factory :booking_resource_sku do
    price { Money.new(rand(100..10000)) }
    quantity { 1 }
    internal { false }
    starts_on { 15.days.from_now }
    ends_on { 1.month.from_now }
    allow_partial_payment { true }

    association :booking
    association :resource_sku
    association :financial_account
    association :cost_center

    trait :removed do
      deleted_at { Time.zone.now }
    end

    trait :canceled do
      transient do
        options { {} }
      end

      after(:create) do |booking_resource_sku, evaluator|
        create :cancellation, { cancellable: booking_resource_sku }.merge(evaluator.options)
      end
    end

    factory :booking_resource_sku_with_attribute_values do
      transient do
        booking_attribute_values_count { 2 }
        booking_attribute_values_options { {} }
      end

      after(:create) do |booking_resource_sku, evaluator|
        evaluator.booking_attribute_values_count.times do
          booking_resource_sku.booking_attribute_values << create(:booking_attribute_value, **evaluator.booking_attribute_values_options)
        end
      end
    end

    factory :booking_resource_sku_with_participants do
      transient do
        participants_count { 2 }
        participants_options { {} }
      end

      after(:create) do |booking_resource_sku, evaluator|
        evaluator.participants_count.times do
          booking_resource_sku.participants << create(:participant, **evaluator.participants_options)
        end
      end
    end

    factory :booking_resource_sku_with_flights do
      transient do
        flights_count { 2 }
        flights_options { {} }
      end

      after(:create) do |booking_resource_sku, evaluator|
        evaluator.flights_count.times do
          booking_resource_sku.flights << create(:flight, **evaluator.flights_options)
        end
      end
    end
  end
end


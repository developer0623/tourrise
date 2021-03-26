# frozen_string_literal: true

FactoryBot.define do
  factory :booking_invoice do
    booking
    created_at { 1.week.ago }

    trait :public do
      scrambled_id { SecureRandom.hex(12) }
    end

    trait :with_booking_resource_sku_groups_snapshot do
      booking_resource_sku_groups_snapshot { [association(:booking_resource_sku_group).serialize_for_snapshot] }
    end

    trait :with_booking_resource_skus_snapshot do
      booking_resource_skus_snapshot { [association(:booking_resource_sku).serialize_for_snapshot] }
    end

    trait :with_booking_credits_snapshot do
      booking_credits_snapshot { [association(:booking_credit).serialize_for_snapshot] }
    end
  end
end

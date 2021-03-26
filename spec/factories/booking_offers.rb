# frozen_string_literal: true

FactoryBot.define do
  factory :booking_offer do
    booking
    created_at { 1.week.ago }
    accepted_at { nil }
    rejected_at { nil }

    trait :public do
      scrambled_id { SecureRandom.hex(12) }
    end

    trait :accepted do
      scrambled_id { SecureRandom.hex(12) }
      accepted_at { 1.day.ago }
    end

    trait :rejected do
      scrambled_id { SecureRandom.hex(12) }
      rejected_at { 1.day.ago }
    end

    trait :with_booking_resource_sku_groups_snapshot do
      booking_resource_sku_groups_snapshot { [association(:booking_resource_sku_group).serialize_for_snapshot] }
    end

    trait :with_booking_resource_skus_snapshot do
      booking_resource_skus_snapshot { [association(:booking_resource_sku).serialize_for_snapshot] }
    end
  end
end

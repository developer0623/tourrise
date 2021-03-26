# frozen_string_literal: true

FactoryBot.define do
  factory :inventory do
    name { Faker::Lorem.word }
    description { Faker::Lorem.paragraph}
    inventory_type { 'quantity' }
  end

  factory :availability do
    quantity { 10 }

    inventory
  end

  factory :reservation, class: "BookingResourceSkuAvailability" do
    booking_resource_sku
    availability

    trait :booked do
      booked_at { Time.zone.now }
      booked_by { association(:user) }
    end

    trait :blocked do
      blocked_at { Time.zone.now }
      blocked_by { association(:user) }
    end
  end
end

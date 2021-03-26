# frozen_string_literal: true

FactoryBot.define do
  factory :booking do
    title { "A booking title" }
    created_at { 1.week.ago }
    starts_on { 15.days.from_now }
    ends_on { 1.month.from_now }

    association :product_sku
    association :customer, factory: :customer
    association :creator, factory: :user

    trait :public do
      scrambled_id { SecureRandom.hex(12) }
    end

    trait :with_assignee do
      association :assignee, factory: :user
    end

    factory :booking_with_room_assignments do
      transient do
        room_assignments_count { 2 }
        room_assignments_options { {} }
      end

      booking_room_assignments do
        Array.new(room_assignments_count) { association(:booking_room_assignment, **room_assignments_options) }
      end
    end

    factory :booking_with_participants do
      transient do
        participants_count { 2 }
        participants_options { {} }
      end

      after(:create) do |booking, evaluator|
        evaluator.participants_count.times do
          booking.participants << create(:participant, **evaluator.participants_options)
        end
      end
    end
  end
end

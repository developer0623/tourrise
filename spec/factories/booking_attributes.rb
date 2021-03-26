# frozen_string_literal: true

FactoryBot.define do
  factory :booking_attribute do
    name { Faker::Lorem.word }
    handle { Faker::Lorem.words(2).join('_') }
    attribute_type { 'number' }
    required { false }

    resource_type
  end
end

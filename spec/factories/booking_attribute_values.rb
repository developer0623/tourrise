# frozen_string_literal: true

FactoryBot.define do
  factory :booking_attribute_value do
    name { Faker::Lorem.word }
    value { Date.today }
    attribute_type { 'date' }

    booking_attribute
    booking_resource_sku
  end
end

# frozen_string_literal: true

FactoryBot.define do
  factory :booking_credit do
    name { Faker::Lorem.sentence }
    price { Money.new(rand(100..10000)) }

    association :booking
    association :financial_account
    association :cost_center
  end
end

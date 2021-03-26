# frozen_string_literal: true

FactoryBot.define do
  factory :payment do
    price { Money.new(rand(100..10000)) }
    due_on { Time.zone.now }

    association :booking_invoice
    association :booking
  end
end

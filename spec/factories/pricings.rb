# frozen_string_literal: true

FactoryBot.define do
  factory :pricing do
    price { Money.new(100_00, 'EUR') }
  end
end

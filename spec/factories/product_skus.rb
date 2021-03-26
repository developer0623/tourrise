# frozen_string_literal: true

FactoryBot.define do
  factory :product_sku do
    name { 'Product Sku' }
    handle { SecureRandom.uuid }
    created_at { 1.week.ago }

    association :product
  end
end

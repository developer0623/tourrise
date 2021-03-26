# frozen_string_literal: true

FactoryBot.define do
  factory :seasonal_product_sku do
    product_sku
    season
  end
end

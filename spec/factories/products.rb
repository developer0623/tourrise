# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    name { 'Product' }

    created_at { 1.week.ago }

    trait :published do
      published_at { 1.day.ago }
    end

    trait :with_sku do
      product_skus_attributes { [{ name: 'Trainingslager Cala Rattata', handle: 'tl-pmi'}] }
    end

    transient do
      product_skus_count { 1 }
    end

    after :build do |product, evaluator|
      product.product_skus << FactoryBot.build_list(:product_sku, evaluator.product_skus_count, product: nil)
    end
  end
end

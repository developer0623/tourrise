# frozen_string_literal: true

FactoryBot.define do
  factory :cancellation do
    association :cancellable, factory: :booking_resource_sku

    cancellation_reason
    user
  end
end

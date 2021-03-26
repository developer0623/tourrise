# frozen_string_literal: true

FactoryBot.define do
  factory :document_reference do
    association :item, factory: :booking_resource_sku
    association :document, factory: :booking_invoice
    event { :added }
    price { Money.new(1000) }

    traits_for_enum :event, DocumentReference.events.keys
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BookingResourceSku, type: :model do
  it 'is referenceable' do
    expect(described_class.included_modules).to include(Referenceable)
  end

  describe '#serialize_for_snapshot' do
    let(:booking_resource_sku) { create(:booking_resource_sku) }
    let(:cost_center) { booking_resource_sku.cost_center }
    let(:financial_account) { booking_resource_sku.financial_account }
    let(:resource) { booking_resource_sku.resource_sku.resource }
    let(:resource_sku) { booking_resource_sku.resource_sku }

    let(:expected_result) do
      {
        "id" => booking_resource_sku.id,
        "booking_id" => booking_resource_sku.booking_id,
        "resource_sku_id" => booking_resource_sku.resource_sku_id,
        "price_cents" => booking_resource_sku.price_cents,
        "starts_on" => booking_resource_sku.starts_on,
        "ends_on" => booking_resource_sku.ends_on,
        "allow_partial_payment" => booking_resource_sku.allow_partial_payment,
        "quantity" => booking_resource_sku.quantity,
        "internal" => booking_resource_sku.internal,
        "booking_attribute_values" => [],
        "flights" => [],
        "participants" => [],
        "resource_sku_snapshot" => {
          "allow_partial_payment" => resource_sku.allow_partial_payment,
          "available" => resource_sku.available,
          "created_at" => resource_sku.created_at.as_json,
          "description" => resource_sku.description,
          "handle" => resource_sku.handle,
          "id" => resource_sku.id,
          "name" => resource_sku.name,
          "occupation_configuration_id" => resource_sku.occupation_configuration_id,
          "resource_id" => resource_sku.resource_id,
          "teaser_text" => resource_sku.teaser_text,
          "updated_at" => resource_sku.updated_at.as_json,
          "vat" => resource_sku.vat.to_s
        },
        "resource_snapshot" => {
          "created_at" => resource.created_at.as_json,
          "description" => resource.description,
          "featured_image_id" => resource.featured_image_id,
          "handle" => resource.handle,
          "id" => resource.id,
          "name" => resource.name,
          "resource_type_id" => resource.resource_type_id,
          "teaser_text" => resource.teaser_text,
          "updated_at" => resource.updated_at.as_json
        },
        "cost_center" => cost_center,
        "financial_account" => financial_account
      }
    end

    it 'correct result' do
      expect(booking_resource_sku.serialize_for_snapshot.as_json).to eq(expected_result.as_json)
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BookingResourceSkuGroup, type: :model do
  it 'is referenceable' do
    expect(described_class.included_modules).to include(Referenceable)
  end

  describe '#serialize_for_snapshot' do
    let(:booking_resource_sku_group) do
      create(:booking_resource_sku_group)
    end

    let(:cost_center) { booking_resource_sku_group.cost_center }
    let(:financial_account) { booking_resource_sku_group.financial_account }

    let(:expected_result) do
      {
        "id" => booking_resource_sku_group.id,
        "booking_id" => booking_resource_sku_group.booking_id,
        "name" => booking_resource_sku_group.name,
        "price" => booking_resource_sku_group.price,
        "price_cents" => booking_resource_sku_group.price_cents,
        "vat" => 0,
        "created_at" => booking_resource_sku_group.created_at,
        "updated_at" => booking_resource_sku_group.updated_at,
        "allow_partial_payment" => booking_resource_sku_group.allow_partial_payment,
        "booking_resource_sku_ids" => booking_resource_sku_group.booking_resource_sku_ids,
        "cost_center" => cost_center,
        "financial_account" => financial_account
      }
    end

    it 'correct result' do
      expect(booking_resource_sku_group.serialize_for_snapshot.as_json).to eq(expected_result.as_json)
    end
  end
end

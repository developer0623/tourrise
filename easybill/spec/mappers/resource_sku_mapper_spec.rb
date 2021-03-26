# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Easybill::ResourceSkuMapper do
  let(:resource_sku) do
    instance_double(
      ResourceSku,
      id: 'resource_sku_id',
      handle: 'a-resource-sku',
      vat: 0.0,
      price: Money.new('2000'),
      calculation_type: :per_person_and_night,
      name: 'What a cool resource sku',
    )
  end

  describe '.to_easybill_position' do
    it 'sets the values' do
      mapped_values = described_class.to_easybill_position(resource_sku)

      expected_values = {
        number: 'a-resource-sku',
        description: 'What a cool resource sku',
        price_type: 'BRUTTO',
        vat_percent: 0.0,
        sale_price: 2000,
      }

      expect(mapped_values).to eq(expected_values)
    end
  end
end


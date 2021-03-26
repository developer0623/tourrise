require 'rails_helper'

RSpec.describe ResourceSkuPricings::LoadResourceSkuPricing, type: :interactor do
  describe '.call' do
    let(:resource_sku_pricing) { instance_double(ResourceSkuPricing) }

    before do
      allow(ResourceSkuPricing).to receive(:find_by_id) { resource_sku_pricing }
    end

    it 'loads the resource_sku_pricing' do
      context = described_class.call(resource_sku_pricing_id: 'pricing_id')

      expect(ResourceSkuPricing).to have_received(:find_by_id).with('pricing_id')
    end

    it 'adds the pricing object to the context' do
      context = described_class.call(resource_sku_pricing_id: 'pricing_id')

      expect(context.resource_sku_pricing).to eq(resource_sku_pricing)
    end

    context 'when something goes wrong' do
      before do
        allow(ResourceSkuPricing).to receive(:find_by_id) { nil }
      end

      it 'sets a message on the context' do
        context = described_class.call(resource_sku_pricing_id: 'pricing_id')

        expect(context.message).to eq(:not_found)
      end
    end
  end
end

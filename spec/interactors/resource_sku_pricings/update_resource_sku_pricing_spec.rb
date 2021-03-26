require 'rails_helper'

RSpec.describe ResourceSkuPricings::UpdateResourceSkuPricing, type: :interactor do
  describe '.call' do
    let(:resource_sku_pricing) { instance_double(ResourceSkuPricing) }
    let(:update_params) do
      {
        price: "10,00",
        participant_type: "participant_type",
        calculation_type: "calculation_type",
      }.stringify_keys
    end

    before do
      allow(ResourceSkuPricings::LoadResourceSkuPricing).to receive(:call!) { true }
      allow(resource_sku_pricing).to receive(:update_attributes) { true }
    end

    it 'loads the resource_sku_pricing' do
      context = described_class.call(params: update_params, resource_sku_pricing: resource_sku_pricing)

      expect(ResourceSkuPricings::LoadResourceSkuPricing).to have_received(:call!).with(context)
    end

    it 'updates the pricing object with the prepared attributes' do
      context = described_class.call(params: update_params, resource_sku_pricing: resource_sku_pricing)

      expected_attributes = {
        price: "10,00",
        participant_type: "participant_type",
        calculation_type: "calculation_type"
      }.stringify_keys

      expect(resource_sku_pricing).to have_received(:update_attributes).with(expected_attributes)
    end

    context 'when something goes wrong' do
      before do
        allow(resource_sku_pricing).to receive(:update_attributes) { false }
        allow(resource_sku_pricing).to receive(:errors) { double(:errors, full_messages: %w[message1 message2]) }
      end

      it 'sets a message on the context' do
        context = described_class.call(params: update_params, resource_sku_pricing: resource_sku_pricing)

        expect(context.message).to contain_exactly("message1", "message2")
      end
    end
  end
end

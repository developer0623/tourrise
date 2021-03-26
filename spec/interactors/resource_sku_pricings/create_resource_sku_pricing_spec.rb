require 'rails_helper'

RSpec.describe ResourceSkuPricings::CreateResourceSkuPricing, type: :interactor do
  describe '.call' do
    let(:resource_sku_pricing) { instance_double(ResourceSkuPricing) }
    let(:create_params) do
      {
        price: "10,00",
        participant_type: "participant_type",
        calculation_type: "calculation_type",
      }.stringify_keys
    end

    before do
      allow(ResourceSkus::LoadResourceSku).to receive(:call) { true }
      allow(ResourceSkuPricing).to receive(:new) { resource_sku_pricing }
      allow(resource_sku_pricing).to receive(:save) { true }
    end

    it 'loads the resource_sku' do
      context = described_class.call(params: create_params)

      expect(ResourceSkus::LoadResourceSku).to have_received(:call).with(context)
    end

    it 'initializes a pricing object with the prepared attributes' do
      context = described_class.call(params: create_params, resource_sku: 'resource_sku')

      expected_attributes = {
        price: "10,00",
        participant_type: "participant_type",
        calculation_type: "calculation_type",
        resource_sku: 'resource_sku'
      }.stringify_keys

      expect(ResourceSkuPricing).to have_received(:new).with(expected_attributes)
    end

    context 'when something goes wrong' do
      before do
        allow(resource_sku_pricing).to receive(:save) { false }
        allow(resource_sku_pricing).to receive(:errors) { double(:errors, full_messages: %w[message1 message2]) }
      end

      it 'sets a message on the context' do
        context = described_class.call(params: create_params)

        expect(context.message).to contain_exactly("message1", "message2")
      end
    end
  end
end

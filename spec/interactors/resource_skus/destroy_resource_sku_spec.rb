require 'rails_helper'

RSpec.describe ResourceSkus::DestroyResourceSku, type: :interactor do
  describe '.call' do
    let(:resource_sku) { instance_double(ResourceSku) }

    before do
      allow(ResourceSkus::LoadResourceSku).to receive(:call!) { true }
      allow(ResourceSkus::PublishResourceSkuDeletedEvent).to receive(:call!) { true }
      allow(resource_sku).to receive(:destroy) { true }
    end

    it 'loads the resource_sku' do
      context = described_class.call(resource_sku_id: 'resource_sku_id', resource_sku: resource_sku)

      expect(ResourceSkus::LoadResourceSku).to have_received(:call!).with(context)
    end

    it 'destroys the resource sku' do
      described_class.call(resource_sku_id: 'resource_sku_id', resource_sku: resource_sku)

      expect(resource_sku).to have_received(:destroy).with(no_args)
    end

    it 'publishes the resource sku destroyed event' do
      context = described_class.call(resource_sku_id: 'resource_sku_id', resource_sku: resource_sku)

      expect(ResourceSkus::PublishResourceSkuDeletedEvent).to have_received(:call!).with(context)
    end

    context 'when something goes wrong' do
      before do
        allow(resource_sku).to receive(:destroy) { false }
        allow(resource_sku).to receive(:errors) { double(:errors, full_messages: "foobar") }
      end

      it 'sets a message on the context' do
        context = described_class.call(resource_sku_id: 'resource_sku_id', resource_sku: resource_sku)

        expect(context.message).to eq("foobar")
      end

      it 'does not publish the resource sku destroyed event' do
        context = described_class.call(resource_sku_id: 'resource_sku_id', resource_sku: resource_sku)

        expect(ResourceSkus::PublishResourceSkuDeletedEvent).not_to have_received(:call!)
      end
    end
  end
end

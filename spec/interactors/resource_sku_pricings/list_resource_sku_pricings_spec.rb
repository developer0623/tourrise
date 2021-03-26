require 'rails_helper'

RSpec.describe ResourceSkuPricings::ListResourceSkuPricings, type: :interactor do
  describe '.call' do
    let(:resource_sku_pricings) { object_double(ResourceSkuPricing.all) }
    let(:resource_sku) { instance_double(ResourceSku) }

    before do
      allow(ResourceSkus::LoadResourceSku).to receive(:call!) { resource_sku }
      allow(resource_sku).to receive(:resource_sku_pricings) { resource_sku_pricings }

      allow(resource_sku_pricings).to receive(:order) { resource_sku_pricings }
    end

    it 'loads the resource sku' do
      context = described_class.call(resource_sku_id: 'resource_sku_id', resource_sku: resource_sku)

      expect(ResourceSkus::LoadResourceSku).to have_received(:call!).with(context)
    end

    it 'loads the pricings that belong to the resource sku' do
      described_class.call(resource_sku_id: 'resource_sku_id', resource_sku: resource_sku)

      expect(resource_sku).to have_received(:resource_sku_pricings).with(no_args)
    end

    it 'sorts the pricings by id by default' do
      described_class.call(resource_sku_id: 'resource_sku_id', resource_sku: resource_sku)

      expect(resource_sku_pricings).to have_received(:order).with("id" => "asc")
    end

    context "with supported sort context" do
      it "sorts the pricings by the provided sort column" do
        described_class.call(resource_sku_id: 'resource_sku_id', resource_sku: resource_sku, sort: { by: "price_cents", order: "desc" })

        expect(resource_sku_pricings).to have_received(:order).with("price_cents" => "desc")
      end
    end
  end
end

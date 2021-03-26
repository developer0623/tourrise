require 'rails_helper'

RSpec.describe SkuPricingStrategies::Custom::KidPricing, type: :service do
  subject { described_class.new(service_params).collect! }

  let(:service_params) do
    {
      pricings: pricings,
      count: count,
      resource_sku_pricing: resource_sku_pricing,
      starts_on: starts_on,
      ends_on: ends_on
    }
  end

  let(:resource_sku_pricing) { create(:resource_sku_pricing) }
  let(:pricings) { ResourceSkuPricing.all }
  let(:count) { 2 }
  let(:starts_on) { Time.zone.now }
  let(:ends_on) { starts_on + 2.days }

  context 'valid' do
    describe 'should select range pricing' do
      let(:range_options) { { resource_sku_pricing: resource_sku_pricing, from: 3, to: 5 } }

      let!(:range1) { create(:consecutive_days_range, range_options) }
      let!(:range2) { create(:consecutive_days_range, resource_sku_pricing: resource_sku_pricing, from: 10, to: nil) }

      it { is_expected.to eq([[1, range1]]) }
    end

    describe "should call by time strategy" do
      let(:range_options) { { resource_sku_pricing: resource_sku_pricing, from: nil, to: 2 } }

      let!(:range) { create(:consecutive_days_range, range_options) }
      let(:by_time_adult_double) { double(collect!: true) }

      it do
        allow(SkuPricingStrategies::ByTime::KidPricing).to receive(:new) { by_time_adult_double }

        subject

        expect(by_time_adult_double).to have_received(:collect!)
     end
    end
  end
end

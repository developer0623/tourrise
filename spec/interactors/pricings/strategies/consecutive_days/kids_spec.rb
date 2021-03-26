require 'rails_helper'

RSpec.describe Pricings::Strategies::ConsecutiveDays, type: :interactor do
  subject { described_class.call(service_params) }

  let(:adults) { 0 }
  let(:kids) { 0 }
  let(:babies) { 0 }

  let(:pricings) { ResourceSkuPricing.all }

  let(:starts_on) { Date.today + 2.days }
  let(:ends_on) { starts_on + 2.days }

  let(:pricing_price) { 1 }

  let(:pricing_dates) { { starts_on: starts_on - 1.day, ends_on: starts_on } }

  let(:service_params) do
    {
      pricings: pricings,
      adults: adults,
      kids: kids,
      babies: babies,
      starts_on: starts_on,
      ends_on: ends_on
    }
  end

  let(:price) { subject.price.to_f }
  let(:applied_pricings) { subject.applied_pricings }

  before {  Timecop.freeze }
  after  {  Timecop.return }

  describe 'should correctly increment price' do
    let(:expected_applied_pricings) { [[count, pricing], [count, pricing]] }

    context 'with kids' do
      let(:kids) { 2 }
      let(:count) { kids }
      let(:sku_pricing_traits) { %i(consecutive_days kid) }

      let(:expected_price) { 4.0 }
      let(:expected_applied_pricings) { [[count, pricing],[count, pricing]] }

      let!(:pricing) do
        create(:resource_sku_pricing,
          *sku_pricing_traits,
          price: pricing_price,
          **pricing_dates
        )
      end

      describe 'with kids pricings' do
        let(:expected_applied_pricings) { [[count, consecutive_days_range]] }
        let(:expected_price) { 1.0 }
        let(:count) { 1 }

        let!(:consecutive_days_range) do
          create(:consecutive_days_range,
            from: 2,
            resource_sku_pricing: pricing,
            price: pricing_price
          )
        end

        it { expect(price).to eq(expected_price) }
        it { expect(applied_pricings).to eq(expected_applied_pricings) }
      end

      describe 'when no kids pricings for particular dates' do
        let(:sku_pricing_traits) { %i(consecutive_days all_groups) }

        describe 'should take all_groups pricing for particular dates' do
          it { expect(price).to eq(expected_price) }
          it { expect(applied_pricings).to eq(expected_applied_pricings) }
        end
      end

      describe 'when no kids pricings for particular dates' do
        let(:pricing_dates) { { starts_on: ends_on + 1.day, ends_on: ends_on + 2.days } }
        let(:expected_applied_pricings) { [[count, pricing],[count, pricing]] }

        describe 'and no price all_groups pricing for particular dates' do
          describe 'should take first kids pricing' do
            it { expect(price).to eq(expected_price) }
            it { expect(applied_pricings).to eq(expected_applied_pricings) }
          end
        end

        describe 'and no price for all groups for particular dates' do
          let(:sku_pricing_traits) { %i(consecutive_days all_groups) }

          describe 'should take the first all_groups pricing despite the dates' do
            it { expect(price).to eq(expected_price) }
            it { expect(applied_pricings).to eq(expected_applied_pricings) }
          end
        end

        describe 'when no kids pricings and no price for all groups for particular dates' do
          let(:sku_pricing_traits) { %i(consecutive_days all_groups) }

          describe 'should take the first price for any groups despite the dates' do
            it { expect(price).to eq(expected_price) }
            it { expect(applied_pricings).to eq(expected_applied_pricings) }
          end
        end
      end

      describe 'when no kids pricings and no price for all groups' do
        let(:sku_pricing_traits) { %i(consecutive_days adult) }

        it { expect(price).to eq(0) }
        it { expect(applied_pricings).to match_array([]) }
      end
    end
  end
end

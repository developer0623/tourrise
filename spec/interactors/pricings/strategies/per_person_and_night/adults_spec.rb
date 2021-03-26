require 'rails_helper'

RSpec.describe Pricings::Strategies::PerPersonAndNight, type: :interactor do
  subject { described_class.call(service_params) }

  let(:adults) { 0 }
  let(:kids) { 0 }
  let(:babies) { 0 }

  let(:pricings) { ResourceSkuPricing.all }

  let(:starts_on) { Date.today + 2.days }
  let(:ends_on) { starts_on + 2.days }

  let(:pricing1_price) { 1 }
  let(:pricing2_price) { 2 }

  let(:pricing1_dates) { { starts_on: starts_on - 1.day, ends_on: starts_on } }
  let(:pricing2_dates) { { starts_on: ends_on - 1.day, ends_on: ends_on } }

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
    let(:expected_applied_pricings) { [[count, first_pricing], [count, second_pricing]] }

    context 'with adults' do
      let(:adults) { 2 }
      let(:count) { adults }
      let(:sku_pricing_traits) { %i(per_person_and_night adult) }

      let(:expected_price) { 6.0 }

      let!(:first_pricing) do
        create(:resource_sku_pricing,
          *sku_pricing_traits,
          price: pricing1_price,
          **pricing1_dates
        )
      end

      let!(:second_pricing) do
        create(:resource_sku_pricing,
          *sku_pricing_traits,
          price: pricing2_price,
          **pricing2_dates
        )
      end

      describe 'with adult pricings' do
        it { expect(price).to eq(expected_price) }
        it { expect(applied_pricings).to eq(expected_applied_pricings) }
      end

      describe 'when no adult pricings for particular dates' do
        let(:sku_pricing_traits) { %i(per_person_and_night all_groups) }

        describe 'should take all_groups pricing for particular dates' do
          it { expect(price).to eq(expected_price) }
          it { expect(applied_pricings).to eq(expected_applied_pricings) }
        end
      end

      describe 'no adult pricings for particular dates' do
        let(:pricing1_dates) { { starts_on: ends_on + 1.day, ends_on: ends_on + 2.days } }
        let(:pricing2_dates) { { starts_on: ends_on + 3.days, ends_on: ends_on + 4.days } }

        let(:expected_applied_pricings) { [[count, first_pricing], [count, first_pricing]] }

        describe 'and no price all_groups pricing for particular dates' do
          let(:expected_price) { 4.0 }

          describe 'should take first adults pricing' do
            it { expect(price).to eq(expected_price) }
            it { expect(applied_pricings).to eq(expected_applied_pricings) }
          end
        end

        describe 'and no price for all groups for particular dates' do
          let(:sku_pricing_traits) { %i(per_person_and_night all_groups) }
          let(:expected_price) { 4.0 }

          describe 'should take the first all_groups pricing despite the dates' do
            it { expect(price).to eq(expected_price) }
            it { expect(applied_pricings).to eq(expected_applied_pricings) }
          end
        end

        describe 'and no price for all groups for particular dates' do
          let(:sku_pricing_traits) { %i(per_person_and_night all_groups) }
          let(:expected_price) { 4.0 }

          describe 'should take the first price for all groups despite the dates' do
            it { expect(price).to eq(expected_price) }
            it { expect(applied_pricings).to eq(expected_applied_pricings) }
          end
        end

      end

      describe 'when no adult pricings and no price for all groups' do
        let(:sku_pricing_traits) { %i(per_person_and_night kid) }

        it { expect(price).to eq(0) }
        it { expect(applied_pricings).to match_array([]) }
      end
    end
  end
end

require 'rails_helper'

RSpec.describe Pricings::Strategies::PerPerson, type: :interactor do
  subject { described_class.call(service_params) }

  let(:adults) { 0 }
  let(:kids) { 0 }
  let(:babies) { 0 }
  let(:count) { adults }
  let(:pricings) { ResourceSkuPricing.all }

  let(:service_params) do
    {
      pricings: pricings,
      adults: adults,
      kids: kids,
      babies: babies
    }
  end

  let(:price) { subject.price }
  let(:applied_pricings) { subject.applied_pricings }

  describe 'should correctly increment price' do
    let(:expected_price) { count * pricings.first.price }
    let(:expected_applied_pricings) { [[count, pricings.first]] }

    context 'no pricings' do
      let(:pricings) { nil }

      it { expect(price).to eq(0) }
      it { expect(applied_pricings).to match_array([]) }
    end

    context 'with adults' do
      let(:adults) { 2 }
      let(:count) { adults }

      describe 'with adult pricings' do
        before { create(:resource_sku_with_pricings, pricings_traits: [:fixed, :adult]) }

        it { expect(price).to eq(expected_price) }
        it { expect(applied_pricings).to eq(expected_applied_pricings) }
      end

      describe 'when no adult pricings' do
        before { create(:resource_sku_with_pricings, pricings_traits: [:fixed, :all_groups]) }

        it { expect(price).to eq(expected_price) }
        it { expect(applied_pricings).to eq(expected_applied_pricings) }
      end

      describe 'when no adult pricings and no price for groups' do
        let(:resource_sku) { create(:resource_sku_with_pricings, pricings_traits: [:fixed, :kid]) }

        it { expect(price).to eq(0) }
        it { expect(applied_pricings).to match_array([]) }
      end
    end

    context 'with kids' do
      let(:kids) { 2 }
      let(:count) { kids }

      describe 'with kid pricings' do
        before { create(:resource_sku_with_pricings, pricings_traits: [:fixed, :kid]) }

        it { expect(price).to eq(expected_price) }
        it { expect(applied_pricings).to eq(expected_applied_pricings) }
      end

      describe 'when no kid pricings' do
        before { create(:resource_sku_with_pricings, pricings_traits: [:fixed, :all_groups]) }

        it { expect(price).to eq(expected_price) }
        it { expect(applied_pricings).to eq(expected_applied_pricings) }
      end

      describe 'when no kid pricings and no price for groups' do
        let(:resource_sku) { create(:resource_sku_with_pricings, pricings_traits: [:fixed, :adult]) }

        it { expect(price).to eq(0) }
        it { expect(applied_pricings).to match_array([]) }
      end
    end

    context 'with babies' do
      let(:babies) { 2 }
      let(:count) { babies }

      describe 'with baby pricings' do
        before { create(:resource_sku_with_pricings, pricings_traits: [:fixed, :baby]) }

        it { expect(price).to eq(expected_price) }
        it { expect(applied_pricings).to eq(expected_applied_pricings) }
      end

      describe 'when no baby pricings' do
        before { create(:resource_sku_with_pricings, pricings_traits: [:fixed, :all_groups]) }

        it { expect(price).to eq(expected_price) }
        it { expect(applied_pricings).to eq(expected_applied_pricings) }
      end

      describe 'when no baby pricings and no price for groups' do
        let(:resource_sku) { create(:resource_sku_with_pricings, pricings_traits: [:fixed, :adult]) }

        it { expect(price).to eq(0) }
        it { expect(applied_pricings).to match_array([]) }
      end
    end
  end
end

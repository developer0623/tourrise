require 'rails_helper'

RSpec.describe Pricings::ResourceSku::GetStrategyOptions, type: :interactor do
  subject { described_class.call(service_params) }

  let(:pricings) { object_double(ResourceSkuPricing.all) }

  let(:adults) { 2 }
  let(:babies) { 2 }
  let(:kids) { 2 }

  let(:service_params) do
    {
      strategy_class: strategy_class,
      pricings: pricings,
      adults: adults,
      kids: kids,
      babies: babies
    }
  end

  let(:expected_options) do
    {
      adults: adults,
      babies: babies,
      kids: kids,
      pricings: expected_pricings
    }
  end

  let(:strategy_class) { Pricings::Strategies::Fixed }
  let(:expected_pricings) { [] }

  describe 'valid' do
    let(:expected_pricings) { [instance_double(ResourceSkuPricing)] }

    before do
      allow(pricings).to receive(pricings_method) { expected_pricings }
    end

    context 'without dates' do
      context '#FixedStrategy options' do
        let(:pricings_method) { :fixed }

        it { is_expected.to be_success }
        it { expect(subject.strategy_options).to eq(expected_options) }
      end

      context '#PerPersonStrategy options' do
        let(:strategy_class) { Pricings::Strategies::PerPerson }
        let(:pricings_method) { :per_person }

        it { is_expected.to be_success }
        it { expect(subject.strategy_options).to eq(expected_options) }
      end
    end

    context 'with dates' do
      let(:starts_on) { Time.now }
      let(:ends_on) { starts_on + 30.minutes }

      let(:service_params) { super().merge(starts_on: starts_on, ends_on: ends_on) }
      let(:expected_options) { super().merge(starts_on: starts_on, ends_on: ends_on) }

      context '#PerPersonAndNightStrategy options' do
        let(:strategy_class) { Pricings::Strategies::PerPersonAndNight }
        let(:pricings_method) { :per_person_and_night }

        it { is_expected.to be_success }
        it { expect(subject.strategy_options).to eq(expected_options) }
      end

      context '#ConsecutiveDaysStrategy options' do
        let(:strategy_class) { Pricings::Strategies::ConsecutiveDays }
        let(:pricings_method) { :consecutive_days }
        let(:resource_sku) { double(:resource_sku) }
        let(:service_params) { super().merge(resource_sku: resource_sku) }
        let(:expected_options) { super().merge(resource_sku: resource_sku) }

        before do
          allow(pricings).to receive(:consecutive_days) { expected_pricings }
        end

        it { is_expected.to be_success }
        it { expect(subject.strategy_options).to eq(expected_options) }
      end
    end
  end

  describe 'invalid' do
    describe 'strategy class is wrong' do
      let(:service_params) { super().merge(strategy_class: :some_key) }
      let(:error_message) { 'No strategy class that meets these conditions!' }

      it { is_expected.not_to be_success }
      it { expect(subject.errors).to include(error_message) }
    end
  end
end

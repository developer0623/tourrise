require 'rails_helper'

RSpec.describe Pricings::ResourceSku::SelectStrategyClass, type: :interactor do
  subject { described_class.call(service_params) }

  let(:service_params) { { resource_sku: resource_sku } }
  let(:resource_sku) { instance_double(ResourceSku) }
  let(:sku_pricings) { object_double(ResourceSkuPricing.all, any?: true) }
  let(:fixed_scope) { [] }
  let(:per_person_scope) { [] }
  let(:consecutive_days_scope) { [] }
  let(:per_person_and_night_scope) { [] }

  let(:contract_double) { double(:contract, call: double(success?: true)) }

  let(:pricings) do
    double(:pricings,
      fixed: fixed_scope,
      per_person: per_person_scope,
      consecutive_days: consecutive_days_scope,
      per_person_and_night: per_person_and_night_scope
    )
  end

  describe 'should correctly select a pricing strategy' do
    before do
      allow(resource_sku).to receive(:resource_sku_pricings) { pricings }
      allow(Pricings::Contracts::SelectStrategy).to receive(:new) { contract_double }
    end

    context '#FixedStrategy' do
      let(:fixed_scope) { sku_pricings }

      it { is_expected.to be_success }
      it { expect(subject.strategy_class).to eq(Pricings::Strategies::Fixed) }
    end

    context '#PerPersonStrategy' do
      let(:per_person_scope) { sku_pricings }

      it { is_expected.to be_success }
      it { expect(subject.strategy_class).to eq(Pricings::Strategies::PerPerson) }
    end

    context '#PerPersonAndNightStrategy' do
      let(:per_person_and_night_scope) { sku_pricings }

      it { is_expected.to be_success }
      it { expect(subject.strategy_class).to eq(Pricings::Strategies::PerPersonAndNight) }
    end

    context '#ConsecutiveDaysStrategy' do
      let(:consecutive_days_scope) { sku_pricings }

      it { is_expected.to be_success }
      it { expect(subject.strategy_class).to eq(Pricings::Strategies::ConsecutiveDays) }
    end
  end

  describe 'invalid' do
    describe 'resource sku is blank' do
      let(:resource_sku) { nil }
      let(:error_message) { ':resource_sku Can only be type of ActiveRecord!' }

      it { is_expected.not_to be_success }
      it { expect(subject.errors).to include(error_message) }
    end

    describe 'no pricing strategy' do
      let(:error_message) { 'No strategy class that meets these conditions!' }

      before do
        allow(resource_sku).to receive(:resource_sku_pricings) { pricings }
        allow(Pricings::Contracts::SelectStrategy).to receive(:new) { contract_double }
      end

      it { is_expected.not_to be_success }
      it { expect(subject.errors).to include(error_message) }
    end
  end
end

require 'rails_helper'

RSpec.describe Pricings::ResourceSku::ApplyPricingStrategy, type: :interactor do
  subject { described_class.call(service_params) }

  let(:service_params) { { strategy_class: strategy_class, strategy_options: strategy_options } }

  let(:adults) { 2 }
  let(:babies) { 2 }
  let(:kids) { 2 }

  let(:pricings) { ResourceSkuPricing.all }
  let(:strategy_class) { Pricings::Strategies::Fixed }

  let(:strategy_options) do
    {
      adults: adults,
      babies: babies,
      kids: kids,
      pricings: pricings
    }
  end

  context 'valid' do
    let(:strategy_double) do
      double(:strategy,
        success?: true,
        price: expected_price,
        applied_pricings: expected_applied_pricings)
    end

    let(:expected_price) { 10.0 }
    let(:expected_applied_pricings) { [] }

    before { allow(strategy_class).to receive(:call).with(strategy_options).and_return(strategy_double) }

    it { is_expected.to be_success }
    it { expect(subject.price).to eq(expected_price) }
    it { expect(subject.applied_pricings).to eq(expected_applied_pricings) }
  end

  context 'invalid' do
    context ':strategy_class' do
      describe 'is blank' do
        let(:service_params) { super().merge(strategy_class: nil) }
        let(:error_message) { 'Strategy class is not in a list of strategies!' }

        it { is_expected.not_to be_success }
        it { expect(subject.errors).to include(error_message) }
      end
    end

    context ':strategy_options' do
      describe 'are blank' do
        let(:service_params) { super().merge(strategy_options: nil) }
        let(:error_message) { 'must be a hash' }

        it { is_expected.not_to be_success }
        it { expect(subject.errors).to include(error_message) }
      end

      describe 'should include :pricings' do
        let(:service_params) { super().merge(strategy_options: {}) }
        let(:error_message) { 'is missing' }

        it { is_expected.not_to be_success }
        it { expect(subject.errors).to include(error_message) }
      end

      describe ':pricings should be ActiveRecord relation' do
        let(:service_params) { super().merge(strategy_options: { pricings: [] }) }
        let(:error_message) { ':pricings Can only be type of ActiveRecord Relation!' }

        it { is_expected.not_to be_success }
        it { expect(subject.errors).to include(error_message) }
      end
    end

    describe 'strategy execution has failed' do
      let(:strategy_double) { double(:strategy, success?: false) }
      let(:described_interactor) { described_class.new(service_params) }
      let(:error_message) { 'Strategy execution failed!' }

      subject { described_interactor.context }

      before do
        allow(described_interactor).to receive(:strategy).and_return(strategy_double)

        described_interactor.run
      end

      it { is_expected.not_to be_success }
      it { expect(subject.errors).to include(error_message) }
    end
  end
end

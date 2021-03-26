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

  describe 'fail' do
    let(:errors) { subject.errors }

    context 'starts_on is blank' do
      let(:starts_on) { nil }
      let(:ends_on) { Date.today + 1.day }

      it { is_expected.not_to be_success }
      it { expect(errors).to include('must be a date') }
    end

    context 'ends_on is blank' do
      let(:ends_on) { nil }

      it { is_expected.not_to be_success }
      it { expect(errors).to include('must be a date') }
    end

    describe ':pricings should be ActiveRecord relation' do
      let(:pricings) { [] }
      let(:error_message) { ':pricings Can only be type of ActiveRecord Relation!' }

      it { is_expected.not_to be_success }
      it { expect(subject.errors).to include(error_message) }
    end

    context 'starts_on > ends_on' do
      let(:ends_on) { Date.today }

      it { is_expected.not_to be_success }
      it { expect(errors).to include('Starts on should be less than ends on!') }
    end
  end

  describe 'should correctly increment price' do
    context 'no pricings' do
      let(:pricings) { ResourceSkuPricing.none }

      it { expect(price).to eq(0) }
      it { expect(applied_pricings).to match_array([]) }
    end
  end
end

require 'rails_helper'

RSpec.describe Pricings::ConsecutiveDays::SelectRange, type: :interactor do
  subject { described_class.call(service_params) }

  let(:service_params) { { ranges: ranges, days: days } }

  let(:ranges) { [range, selected_range] }
  let(:range_options) { { from: from, to: to } }

  let(:selected_range) { create(:consecutive_days_range, range_options) }
  let(:range) { create(:consecutive_days_range, from: 10, to: nil) }

  let(:from) { nil }
  let(:to) { nil }
  let(:days) { 3 }

  context 'valid' do
    describe 'returns correct range' do
      describe 'fits range' do
        let(:from) { 3 }
        let(:to) { 5 }

        it { is_expected.to be_success }
        it { expect(subject.range).to eq(selected_range) }
      end

      describe "doesn't fit any range" do
        let(:to) { 3 }
        let(:days) { 4 }

        it { is_expected.to be_success }
        it { expect(subject.range).to be_nil }
      end
    end
  end
end

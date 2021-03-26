require 'rails_helper'

RSpec.describe BookingResourceSkus::RecalculatePrice::ForAll, type: :interactor do
  describe "correctly organizes classes" do
    subject { described_class.organized }

    let(:expected_organized_classes) do
      [
        BookingResourceSkus::RecalculatePrice::ForCreated,
        BookingResourceSkus::RecalculatePrice::ForUpdated,
        BookingResourceSkus::RecalculatePrice::ForCanceled
      ]
    end

    it { is_expected.to eq(expected_organized_classes) }
  end
end

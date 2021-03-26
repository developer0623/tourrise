require 'rails_helper'

RSpec.describe Documents::RecalculatePositionsPrice, type: :interactor do
  describe "correctly organizes classes" do
    subject { described_class.organized }

    let(:expected_organized_classes) do
      [
        BookingResourceSkus::RecalculatePrice::ForAll,
        BookingResourceSkuGroups::RecalculatePrice::ForAll,
        BookingCredits::RecalculatePrice::ForAll
      ]
    end

    it { is_expected.to eq(expected_organized_classes) }
  end
end

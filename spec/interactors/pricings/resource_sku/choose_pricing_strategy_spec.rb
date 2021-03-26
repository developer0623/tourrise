require 'rails_helper'

RSpec.describe Pricings::ResourceSku::ChoosePricingStrategy, type: :interactor do
  let(:organizer) { described_class }

  subject { organizer.call(service_params) }

  let(:booking) { create(:booking_with_room_assignments) }
  let(:booking_room_assignment) { booking.booking_room_assignments.first }
  let(:resource_sku) { create(:resource_sku) }

  let(:service_params) do
    {
      resource_sku: resource_sku,
      starts_on: booking.starts_on,
      ends_on: booking.ends_on,
      adults: booking_room_assignment.adults,
      kids: booking_room_assignment.kids,
      babies: booking_room_assignment.babies
    }
  end

  let(:interactors) do
    [
      Pricings::ResourceSku::SelectStrategyClass,
      Pricings::ResourceSku::GetStrategyOptions
    ]
  end

  it { expect(organizer.organized).to eq(interactors) }

  describe 'calls interactors' do
    before do
      expect(Pricings::ResourceSku::SelectStrategyClass).to receive(:call!).once
      expect(Pricings::ResourceSku::GetStrategyOptions).to receive(:call!).once
    end

    it { is_expected.to be_success }
  end
end

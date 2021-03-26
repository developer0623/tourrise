# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Bookings::CloseBooking, type: :interactor do
  describe '.call' do
    before do
      allow(Bookings::LoadBooking).to receive(:call!) { true }
      allow(Bookings::ResetDueDate).to receive(:call!) { true }
      allow(Bookings::ChangeBookingState).to receive(:call!) { true }
      allow(Bookings::ChangeSecondaryState).to receive(:call!) { true }
      allow(Bookings::UnblockBookingResourceSkus).to receive(:call!) { true }
      allow(Bookings::PublishBookingClosedEvent).to receive(:call!) { true }
    end

    it 'calls the change booking state interactor with the right context' do
      context = described_class.call

      expect(context.transition_method_name).to eq(:close)
    end

    it 'succeeds' do
      context = described_class.call

      expect(context).to be_success
    end
  end

  it 'organizes the correct interactors' do
    expected_organized_classes = [
      Bookings::LoadBooking,
      Bookings::ResetDueDate,
      Bookings::ChangeBookingState,
      Bookings::ChangeSecondaryState,
      Bookings::UnblockBookingResourceSkus,
      Bookings::PublishBookingClosedEvent
    ]

    expect(described_class.organized).to eq(expected_organized_classes)
  end
end

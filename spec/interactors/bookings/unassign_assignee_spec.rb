# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Bookings::UnassignAssignee, type: :interactor do
  describe '.call' do
    before do
      allow(Bookings::LoadBooking).to receive(:call!) { true }
      allow(Bookings::UpdateAssignee).to receive(:call!) { true }
      allow(Bookings::ChangeBookingState).to receive(:call!) { true }
      allow(Bookings::ChangeSecondaryState).to receive(:call!) { true }
    end

    it 'calls the change booking state interactor with the right context' do
      context = described_class.call

      expect(context.transition_method_name).to eq(:release)
    end

    it 'succeeds' do
      context = described_class.call

      expect(context).to be_success
    end
  end

  it 'organizes the correct interactors' do
    expected_organized_classes = [
      Bookings::LoadBooking,
      Bookings::UpdateAssignee,
      Bookings::ChangeBookingState,
      Bookings::ChangeSecondaryState
    ]

    expect(described_class.organized).to eq(expected_organized_classes)
  end
end
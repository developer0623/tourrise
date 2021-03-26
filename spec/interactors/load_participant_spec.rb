require 'rails_helper'

RSpec.describe LoadParticipant, type: :interactor do
  subject(:context) { described_class.call(booking_id: 'booking_id', participant_id: 'participant_id') }
  let(:participant) { double(:participant) }
  let(:participants) { double(:participants) }
  let(:booking) { double(:booking, participants: participants) }

  describe '.call' do
    context 'when the participant exists' do

      before do
        allow(Booking).to receive(:find_by).with(id: 'booking_id') { booking }
        allow(booking.participants).to receive(:find_by).with(id: 'participant_id') { participant }
      end

      it 'succeeds' do
        expect(context).to be_success
      end

      it 'provides the participant' do
        expect(context.participant).to eq(participant)
      end

      it 'booking the booking' do
        expect(context.booking).to eq(booking)
      end
    end

    context 'when the participant does not exists' do
      before do
        allow(Booking).to receive(:find_by).with(id: 'booking_id') { booking }
        allow(booking.participants).to receive(:find_by).with(id: 'participant_id') { nil }
      end

      it 'fails' do
        expect(context).to be_failure
      end

      it 'provides the error message' do
        expect(context.message).to eq(:not_found)
      end
    end
  end
end

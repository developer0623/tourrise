require 'rails_helper'

RSpec.describe UpdateParticipant, type: :interactor do
  subject(:context) do
    described_class.call(
      booking_id: 'booking_id',
      participant_id: 'participant_id',
      params: 'data'
    )
  end

  describe '.call' do
    let(:participant) { double(:participant, reload: true) }
    let(:participants) { double(:participants) }
    let(:booking) { double(:booking, participants: participants) }

    before do
      allow(Booking).to receive(:find_by).with(id: 'booking_id') { booking }
      allow(booking.participants).to receive(:find_by).with(id: 'participant_id') { participant }
      allow(participant).to receive(:update).with('data') { true }
    end

    it 'provides the participant' do
      expect(context.participant).to eq(participant)
    end

    context 'when the update succeeds' do
      it 'succeeds' do
        expect(context).to be_success
      end

      it 'reloads the provided participant' do
        context

        expect(participant).to have_received(:reload)
      end
    end

    context 'when the participant does not exists' do
      before do
        allow(participant).to receive(:update).with('data') { false }
        allow(participant).to receive(:errors) { :not_found }
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

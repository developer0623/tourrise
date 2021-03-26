require 'rails_helper'

RSpec.describe Bookings::ChangeBookingState, type: :interactor do
  describe '.call' do
    let(:booking) { instance_double(Booking, aasm_state: 'new') }
    let(:call_params) do
      {
        booking: booking,
        transition_method_name: :process
      }
    end

    before do
      allow(booking).to receive(:may_process?) { true }
      allow(booking).to receive(:process!) { true }
    end

    it 'memoizes the current state' do
      context = described_class.call(call_params)

      expect(context.memoized_state).to eq('new')
    end

    it 'calls the transistion method on the booking' do
      described_class.call(call_params)

      expect(booking).to have_received(:process!).with(no_args)
    end

    it 'sets a success context' do
      context = described_class.call(call_params)

      expect(context).to be_success
    end

    context 'when the transition method name context is missing' do
      let(:call_params) { { booking: booking } }

      it 'raises an error' do
        expect {
          described_class.call(call_params)
        }.to raise_error 'invalid usage. no transition method defined'
      end
    end

    context 'when the booking cannot transition into the desired state' do
      before do
        allow(booking).to receive(:may_process?) { false }
      end

      it 'sets a failure context' do
        context = described_class.call(call_params)

        expect(context).to be_failure
      end

      it 'sets the error message' do
        context = described_class.call(call_params)

        expect(context.message).to eq('Cannot process booking. Booking is in state new.')
      end
    end
  end

  describe '.rollback' do
    let(:booking) { instance_double(Booking, aasm_state: 'new') }
    let(:call_params) do
      {
        booking: booking,
        memoized_state: 'previous_state'
      }
    end

    before do
      allow(booking).to receive(:update_column) { true }
    end

    it 'it sets the state to the memoized state' do
      described_class.new(call_params).rollback

      expect(booking).to have_received(:update_column).with(:aasm_state, 'previous_state')
    end
  end
end
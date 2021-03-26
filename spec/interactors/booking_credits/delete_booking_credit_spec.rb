# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BookingCredits::DeleteBookingCredit, type: :interactor do
  let(:booking_credit) { instance_double(BookingCredit, invoiced?: false, destroy: true) }

  it 'is a success' do
    result = described_class.call(booking_credit: booking_credit)

    expect(result).to be_success
  end

  context 'when destroy fails' do
    before do
      allow(booking_credit).to receive(:destroy) { false }
      allow(booking_credit).to receive(:errors) { double(:errors, full_messages: "error_messages") }
    end

    it 'is a failure' do
      result = described_class.call(booking_credit: booking_credit)

      expect(result).to be_failure
    end

    it 'sets an error message' do
      result = described_class.call(booking_credit: booking_credit)

      expect(result.message).to eq("error_messages")
    end
  end

  context 'when the booking credit is invoiced' do
    before do
      allow(booking_credit).to receive(:invoiced?) { true }
    end

    it 'is a failure' do
      result = described_class.call(booking_credit: booking_credit)

      expect(result).to be_failure
    end

    it 'sets an error message' do
      result = described_class.call(booking_credit: booking_credit)

      expect(result.message).to eq(I18n.t('booking_credits.destroy.already_invoiced_error'))
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Bookings::ListBookings do
  describe '.call' do
    let(:bookings) { double(:bookings) }

    before do
      allow(Booking).to receive(:without_drafts) { bookings }
      allow(bookings).to receive(:includes) { bookings }
      allow(bookings).to receive(:with_product_translations) { bookings }
      allow(bookings).to receive(:with_product_sku_translations) { bookings }
      allow(bookings).to receive(:page) { double(:page, per: []) }
    end

    it 'returns an array of all bookings' do
      allow(Booking).to receive(:all).and_return(bookings)

      result = described_class.call

      expect(result.bookings).to eq([])
    end
  end
end

require 'rails_helper'

RSpec.describe BookingOffersService, type: :service do
  let(:booking) { instance_double(Booking) }

  let(:service) { described_class.new(booking) }

  describe "#offer_available?" do
    it "is the same as #document_available?" do
      expect(service.method(:offer_available?)).to eq(service.method(:document_available?))
    end
  end

  describe "#offer_creatable?" do
    it "is the same as #document_creatable?" do
      expect(service.method(:offer_creatable?)).to eq(service.method(:document_creatable?))
    end
  end

  describe '#document_type' do
    it 'has the correc ttype' do
      expect(service.send(:document_type)).to eq("BookingOffer")
    end
  end
end
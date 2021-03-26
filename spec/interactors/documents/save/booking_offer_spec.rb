require 'rails_helper'

RSpec.describe Documents::Save::BookingOffer, type: :interactor do
  subject { described_class.call(document: document, booking: booking) }

  let(:booking) { instance_double(Booking) }
  let(:total_price) { 100 }
  let(:document) { instance_double(BookingOffer, document_methods) }
  let(:document_methods) do
    { id: "id", booking_id: "booking_id", total_price: total_price, save: true }
  end

  let(:publish_payload) { { "id" => document.id, "booking_id" => document.booking_id } }

  before do
    allow(BookingService).to receive(:new).with(booking) { booking_service_double }

    allow(PublishEventJob).to receive(:perform_later).with(Event::BOOKING_OFFER_CREATED, publish_payload)
  end

  let(:booking_service_double) { double(:booking_service, offer_creatable?: true) }

  describe "success" do
    it { is_expected.to be_success }

    context "message sending" do
      before { subject }

      it { expect(PublishEventJob).to have_received(:perform_later).with(Event::BOOKING_OFFER_CREATED, publish_payload) }
    end
  end

  describe "failure" do
    let(:expected_message) { 'error message' }

    describe "offer is not creatable" do
      let(:booking_service_double) { double(:booking_service, offer_creatable?: false) }

      it { is_expected.to be_failure }

      context "message is right" do
        before do
          allow(I18n).to receive(:t).with("booking_offers.created_error") { expected_message }
        end

        it { expect(subject.message).to eq(expected_message) }
      end
    end

    describe "offer can't be saved" do
      let(:document_methods) do
        super().merge(save: false, errors: double(full_messages: expected_message))
      end

      it { is_expected.to be_failure }

      context "message is right" do
        before do
          allow(I18n).to receive(:t).with("booking_offers.new.invalid_price_error") { expected_message }
        end

        it { expect(subject.message).to eq(expected_message) }
      end
    end
  end
end

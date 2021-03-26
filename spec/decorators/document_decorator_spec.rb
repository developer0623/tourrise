require 'rails_helper'

RSpec.describe BookingDocumentDecorator do
  let(:document) { instance_double(BookingInvoice, booking: booking, scrambled_id: 'document_scrambled_id', class: BookingInvoice) }
  let(:booking) { instance_double(Booking, scrambled_id: 'booking_scrambled_id') }
  let(:decorated_document) { described_class.decorate(document) }

  describe "#customer_link" do
    context "when no external preview url is configured" do
      it "returns an empty string" do
        expect(decorated_document.customer_link).to be_blank
      end
    end

    context "when an external preview url is configured" do
      let(:frontoffice_setting) { instance_double(FrontofficeSetting) }

      before do
        allow(FrontofficeSetting).to receive(:any?) { true }
        allow(FrontofficeSetting).to receive(:first) { frontoffice_setting }
        allow(frontoffice_setting).to receive(:external_document_preview_url) do
          "https://www.example.com/documents?booking_id={{booking_id}}&document_type={{document_type}}&document_id={{document_id}}"
        end
      end

      it "returns the external url with the replaced placeholders" do
        link = decorated_document.customer_link

        expected_link = "<a target=\"_blank\" href=\"https://www.example.com/documents?booking_id=booking_scrambled_id&amp;document_type=invoices&amp;document_id=document_scrambled_id\">Kundenansicht</a>"

        expect(decorated_document.customer_link).to eq(expected_link)
      end
    end
  end
end

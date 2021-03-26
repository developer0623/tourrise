require 'rails_helper'

RSpec.describe BookingResourceSkus::FindCanceled, type: :interactor do
  subject { described_class.call(booking: booking, document_type: document_type) }

  let(:booking) { create(:booking) }
  let(:document_type) { "BookingInvoice" }
  let(:document) { build(:booking_invoice, booking: booking) }

  context 'valid' do
    describe "no canceled booking resource skus" do
      let(:expected_booking_resource_skus) { [] }

      before do
        booking_resource_sku = create(:booking_resource_sku, booking: booking)

        booking_resource_sku.paper_trail_event = "cancel"
        booking_resource_sku.paper_trail.save_with_version
      end

      it { is_expected.to be_success }
      it { expect(subject.canceled_booking_resource_skus).to match_array(expected_booking_resource_skus) }
    end

    describe "canceled and already invoiced" do
      let!(:booking_resource_sku) { create(:booking_resource_sku, booking: booking) }
      let!(:booking_invoice1) { create(:booking_invoice, booking: booking) }

      before do
        booking_resource_sku.paper_trail_event = "cancel"
        booking_resource_sku.paper_trail.save_with_version

        create(:document_reference, item: booking_resource_sku, document: booking_invoice1, item_version_id: booking_resource_sku.versions.last.id)
      end

      let(:expected_booking_resource_skus) { [] }

      it { is_expected.to be_success }
      it { expect(subject.canceled_booking_resource_skus).to match_array(expected_booking_resource_skus) }
    end

    describe "canceled but not invoiced yet" do
      let!(:booking_resource_sku) { create(:booking_resource_sku, booking: booking) }
      let!(:booking_invoice1) { create(:booking_invoice, booking: booking) }
      let!(:document_reference) { create(:document_reference, item: booking_resource_sku, document: booking_invoice1, item_version_id: booking_resource_sku.versions.last.id) }

      let(:expected_booking_resource_skus) { [booking_resource_sku] }

      before do
        booking_resource_sku.paper_trail_event = "cancel"
        booking_resource_sku.paper_trail.save_with_version
      end

      it { is_expected.to be_success }
      it { expect(subject.canceled_booking_resource_skus).to match_array(expected_booking_resource_skus) }
    end
  end

  context 'invalid' do
    describe "booking is empty" do
      let(:booking) { nil }
      let(:expected_message) { I18n.t("interactor_errors.empty", attribute: :booking) }

      it { is_expected.to be_failure }
      it { expect(subject.message).to eq(expected_message) }
    end
  end
end

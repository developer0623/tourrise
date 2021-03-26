require 'rails_helper'

RSpec.describe BookingResourceSkus::FindCreated, type: :interactor do
  subject { described_class.call(booking: booking, document_type: document_type) }

  let(:booking) { create(:booking) }
  let(:document_type) { "BookingInvoice" }

  context 'valid' do
    describe "no created booking resource skus" do
      let(:expected_booking_resource_skus) { [] }

      before do
        booking_resource_sku = create(:booking_resource_sku, booking: booking)

        booking_resource_sku.destroy
      end

      it { is_expected.to be_success }
      it { expect(subject.created_booking_resource_skus).to match_array(expected_booking_resource_skus) }
    end

    describe "created and already invoiced" do
      let!(:booking_resource_sku) { create(:booking_resource_sku, booking: booking) }
      let!(:booking_invoice1) { create(:booking_invoice, booking: booking) }
      let!(:document_reference) { create(:document_reference, item: booking_resource_sku, document: booking_invoice1, item_version_id: booking_resource_sku.versions.last.id) }

      let(:expected_booking_resource_skus) { [] }

      it { is_expected.to be_success }
      it { expect(subject.created_booking_resource_skus).to match_array(expected_booking_resource_skus) }
    end

    describe "created but not invoiced yet" do
      let!(:booking_resource_sku) { create(:booking_resource_sku, booking: booking) }
      let(:expected_booking_resource_skus) { [booking_resource_sku] }

      context "previous invoice does not exist" do
        it { is_expected.to be_success }
        it { expect(subject.created_booking_resource_skus).to match_array(expected_booking_resource_skus) }
      end

      context "previous invoice exists" do
        let!(:booking_invoice1) { create(:booking_invoice, booking: booking) }

        it { is_expected.to be_success }
        it { expect(subject.created_booking_resource_skus).to match_array(expected_booking_resource_skus) }
      end
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

require 'rails_helper'

RSpec.describe BookingResourceSkus::Find, type: :interactor do
  subject { described_class.call(booking: booking, document_type: document_type) }

  let(:booking) { create(:booking) }
  let(:document_type) { "BookingInvoice" }

  it 'organizes the correct interactors' do
    expected_organized_classes = [
      BookingResourceSkus::FindCreated,
      BookingResourceSkus::FindUpdated,
      BookingResourceSkus::FindCanceled,
      BookingResourceSkus::CollectForDocument
    ]

    expect(described_class.organized).to eq(expected_organized_classes)
  end

  context "valid" do
    let!(:booking_invoice) { create(:booking_invoice, booking: booking) }
    let!(:canceled_booking_resource_skus) { [canceled_booking_resource_sku] }
    let(:canceled_booking_resource_sku) { create(:booking_resource_sku, booking: booking) }
    let!(:created_booking_resource_skus) { [create(:booking_resource_sku, booking: booking)] }
    let!(:updated_booking_resource_skus) { [updated_booking_resource_sku] }
    let(:updated_booking_resource_sku) { create(:booking_resource_sku, booking: booking) }
    let(:update_attributes) { { price_cents: 500 } }

    let!(:reference_for_canceled) do
      create(:document_reference,
        item: canceled_booking_resource_sku,
        document: booking_invoice,
        item_version_id: canceled_booking_resource_sku.versions.last.id
      )
    end

    let!(:reference_for_updated) do
      create(:document_reference,
        item: updated_booking_resource_sku,
        document: booking_invoice,
        item_version_id: updated_booking_resource_sku.versions.last.id
      )
    end

    before do
      canceled_booking_resource_sku.paper_trail_event = "cancel"
      canceled_booking_resource_sku.paper_trail.save_with_version

      updated_booking_resource_sku.update(update_attributes)
    end

    it { is_expected.to be_success }

    it { expect(subject.created_booking_resource_skus).to eq(created_booking_resource_skus) }
    it { expect(subject.updated_booking_resource_skus).to eq(updated_booking_resource_skus) }
    it { expect(subject.canceled_booking_resource_skus).to eq(canceled_booking_resource_skus) }
  end

  context "invalid" do
    describe "booking is empty" do
      let(:booking) { nil }
      let(:expected_message) { I18n.t("interactor_errors.empty", attribute: :booking) }

      it { is_expected.to be_failure }
      it { expect(subject.message).to eq(expected_message) }
    end
  end
end

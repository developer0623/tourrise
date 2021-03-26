require 'rails_helper'

RSpec.describe Documents::AddDocumentReferences::ForDocument, type: :interactor do
  describe "correctly organized" do
    subject { described_class.organized }

    let(:expected_organized_classes) do
      [
        BookingResourceSkus::AddDocumentReferences::ForAll,
        BookingResourceSkuGroups::AddDocumentReferences::ForAll,
        BookingCredits::AddDocumentReferences::ForAll
      ]
    end

    it { is_expected.to eq(expected_organized_classes) }
  end

  subject { described_class.call(**interactor_params) }

  let(:interactor_params) do
    {
      document: document,
      created_booking_resource_skus: created_booking_resource_skus,
      updated_booking_resource_skus: [],
      canceled_booking_resource_skus: [],
      created_booking_resource_sku_groups: created_booking_resource_sku_groups,
      updated_booking_resource_sku_groups: [],
      canceled_booking_resource_sku_groups: [],
      created_booking_credits: created_booking_credits,
      updated_booking_credits: [],
      removed_booking_credits: [],
      created_booking_resource_skus_price_info: created_booking_resource_skus_price_info,
      updated_booking_resource_skus_price_info: {},
      canceled_booking_resource_skus_price_info: {},
      created_booking_resource_sku_groups_price_info: created_booking_resource_sku_groups_price_info,
      updated_booking_resource_sku_groups_price_info: {},
      canceled_booking_resource_sku_groups_price_info: {},
      created_booking_credits_price_info: created_booking_credits_price_info,
      updated_booking_credits_price_info: {},
      removed_booking_credits_price_info: {}
    }
  end

  let(:document) { instance_double(BookingInvoice) }
  let(:created_booking_resource_skus) { [] }
  let(:created_booking_resource_sku_groups) { [] }
  let(:created_booking_credits) { [] }
  let(:created_booking_resource_skus_price_info) { {} }
  let(:created_booking_resource_sku_groups_price_info) { {} }
  let(:created_booking_credits_price_info) { {} }
  let(:price) { 0 }

  before do
    allow(Documents::AddDocumentReference).to receive(:call) { true }
  end

  describe "success" do
    describe "add references to booking_resource_skus" do
      let(:price) { 500 }
      let(:created_booking_resource_skus) { [booking_resource_sku] }
      let(:booking_resource_sku) { instance_double(BookingResourceSku, id: "id") }
      let(:created_booking_resource_skus_price_info) { { booking_resource_sku.id => { total_price: price } } }

      it { is_expected.to be_success }

      it do
        expect(Documents::AddDocumentReference).to receive(:call).with(document: document, item: booking_resource_sku, event: "added", price: price)

        subject
      end
    end

    describe "add references to booking_resource_sku_groups" do
      let(:price) { 500 }
      let(:created_booking_resource_sku_groups) { [booking_resource_sku_group] }
      let(:booking_resource_sku_group) { instance_double(BookingResourceSkuGroup, id: "id") }
      let(:created_booking_resource_sku_groups_price_info) { { booking_resource_sku_group.id => { total_price: price } } }

      it { is_expected.to be_success }

      it do
        expect(Documents::AddDocumentReference).to receive(:call).with(document: document, item: booking_resource_sku_group, event: "added", price: price)

        subject
      end
    end

    describe "add references to booking_credits" do
      let(:created_booking_credits) { [booking_credit] }
      let(:booking_credit) { instance_double(BookingCredit, id: 'credit_id') }
      let(:created_booking_credits_price_info) { { booking_credit.id => { total_price: price } } }

      it { is_expected.to be_success }

      it do
        expect(Documents::AddDocumentReference).to receive(:call).with(document: document, item: booking_credit, event: "added", price: price)

        subject
      end
    end

    describe "booking_resource_skus are blank" do
      let(:created_booking_resource_skus) { nil }

      it { is_expected.to be_success }
    end

    describe "booking_resource_sku_groups are blank" do
      let(:created_booking_resource_sku_groups) { nil }

      it { is_expected.to be_success }
    end

    describe "booking_credits are blank" do
      let(:booking_credits) { nil }

      it { is_expected.to be_success }
    end
  end

  describe "failure" do
    describe "document is empty" do
      let(:document) { nil }
      let(:expected_message) { I18n.t("interactor_errors.empty", attribute: :document) }

      it { is_expected.to be_failure }
      it { expect(subject.message).to eq(expected_message) }
    end
  end
end

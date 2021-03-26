# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Documents::InitializeMainAttributes::BookingOffer, type: :interactor do
  subject { described_class.call(**interactor_params) }

  let(:interactor_params) do
    {
      booking: booking,
      booking_resource_skus: booking_resource_skus,
      booking_resource_sku_groups: booking_resource_sku_groups,
      booking_credits: booking_credits
    }
  end

  let(:booking) { instance_double(Booking, **booking_methods) }
  let(:booking_methods) do
    { customer: customer, product_sku: product_sku, resource_skus: resource_skus }
  end
  let(:customer) { instance_double(Customer) }
  let(:product_sku) { instance_double(ProductSku) }
  let(:resource_skus) { [instance_double(ResourceSku)] }

  let(:booking_resource_skus) { [instance_double(BookingResourceSku, serialize_for_snapshot: true)] }
  let(:booking_resource_sku_groups) { [instance_double(BookingResourceSkuGroup, serialize_for_snapshot: true)] }
  let(:booking_credits) { [instance_double(BookingCredit, serialize_for_snapshot: true)] }
  let(:document_double) { double(:document) }

  before do
    allow(BookingOffer).to receive(:new) { document_double }
  end

  describe "success" do
    it { is_expected.to be_success }

    describe "initializes document correctly" do
      it { expect(subject.document).to eq(document_double) }
    end

    describe "booking_resource_skus are nil" do
      let(:booking_resource_skus) { nil }

      it { is_expected.to be_success }
    end

    describe "booking_resource_sku_groups are nil" do
      let(:booking_resource_sku_groups) { nil }

      it { is_expected.to be_success }
    end

    describe "booking_credits are nil" do
      let(:booking_credits) { nil }

      it { is_expected.to be_success }
    end
  end

  describe "failure" do
    describe "booking is empty" do
      let(:booking) { nil }
      let(:expected_message) { I18n.t("interactor_errors.empty", attribute: :booking) }

      it { is_expected.to be_failure }
      it { expect(subject.message).to eq(expected_message) }
    end
  end
end

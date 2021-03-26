# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Documents::Initialize::Positions, type: :interactor do
  subject { described_class.call(**interactor_params) }

  let(:interactor_params) do
    {
      booking: booking,
      canceled_booking_resource_skus: [],
      updated_booking_resource_skus: [],
      created_booking_resource_skus: booking_resource_skus
    }
  end

  let(:booking) { instance_double(Booking) }

  let(:booking_resource_skus) { [instance_double(BookingResourceSku)] }
  let(:booking_resource_sku_groups) { [instance_double(BookingResourceSkuGroup)] }
  let(:booking_credits) { [instance_double(BookingCredit)] }

  before do
    allow(BookingInvoicesService).to receive(:new) { booking_invoices_service_double }

    allow(BookingResourceSkus::Find).to receive(:call) { double(booking_resource_skus: booking_resource_skus) }
    allow(BookingResourceSkuGroups::Find).to receive(:call) { double(booking_resource_sku_groups: booking_resource_sku_groups) }
    allow(BookingCredits::Find).to receive(:call) { double(booking_credits: booking_credits) }
  end

  describe "success" do
    it { is_expected.to be_success }

    describe "return correct positions" do
      it { expect(subject.booking_resource_skus).to eq(booking_resource_skus) }
      it { expect(subject.booking_resource_sku_groups).to eq(booking_resource_sku_groups) }
      it { expect(subject.booking_credits).to eq(booking_credits) }
    end
  end
end

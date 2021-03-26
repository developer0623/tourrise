# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Documents::Create::AdvanceBookingInvoice, type: :interactor do
  let(:customer) { instance_double(Customer) }
  let(:product_sku) { instance_double(ProductSku) }
  let(:booking) { instance_double(Booking, id: 'booking_id', customer: customer, product_sku: product_sku) }
  let(:payment) { instance_double(Payment, price: 100, price_cents: 10000) }
  let(:errors) { double(:errors, full_messages: 'invalid_advance_booking_invoice') }
  let(:advance_booking_invoice) { instance_double(AdvanceBookingInvoice, payments: [payment], errors: errors) }
  let(:booking_credit) { instance_double(BookingCredit) }
  let(:create_params) do
    {
      payments_attributes: { "0" => { "price"=>"10", "due_on"=>"2020-10-10" } },
      "description" => "some_description",
      "booking_credit" => { "financial_account_id"=>"1", "cost_center_id"=>"2" }
    }
  end

  let(:advance_payment_snapshot) do
    {
      "booking_id"=>"booking_id",
      "created_at"=>nil,
      "id"=>nil,
      "name" => I18n.t("booking_credits.advance_booking_invoice.title"),
      "price_cents" => 10000,
      "price_currency"=>"EUR",
      "quantity"=>1,
      "resource_sku_snapshot"=>{"handle"=>"-", "name"=>I18n.t("booking_credits.advance_booking_invoice.title")},
      "updated_at"=>nil,
      "financial_account_id" => 1,
      "cost_center_id" => 2
    }
  end

  describe '.call' do
    before do
      allow(Booking).to receive(:find_by_id) { booking }
      allow(AdvanceBookingInvoice).to receive(:new) { advance_booking_invoice }
      allow(advance_booking_invoice).to receive(:assign_attributes)
      allow(advance_booking_invoice).to receive(:booking_resource_skus_snapshot=)
      allow(advance_booking_invoice).to receive(:save) { true }
      allow(BookingCredit).to receive(:new) { booking_credit }
      allow(booking_credit).to receive(:serialize_as_booking_resource_sku_snapshot) { advance_payment_snapshot }
      allow(booking_credit).to receive(:save)
      allow(PublishEventJob).to receive(:perform_later)
    end

    it 'loads the booking' do
      described_class.call(booking_id: booking.id, params: create_params)

      expect(Booking).to have_received(:find_by_id).with('booking_id')
    end

    it 'assigns the state as snapshots to the booking invoice' do
      context = described_class.call(booking_id: booking.id, params: create_params)

      expect(AdvanceBookingInvoice).to have_received(:new).with(
        booking: booking,
        booking_snapshot: booking,
        customer_snapshot: customer,
        product_sku_snapshot: product_sku,
        booking_resource_sku_groups_snapshot: [],
        booking_resource_skus_snapshot: [],
        booking_credits_snapshot: []
      )
    end

    it 'creates an advance booking invoice' do
      context = described_class.call(booking_id: booking.id, params: create_params)

      expect(advance_booking_invoice).to have_received(:save)
    end

    it 'is successful' do
      context = described_class.call(booking_id: booking.id, params: create_params)

      expect(context.success?).to be(true)
    end

    it 'publishes the message' do
      context = described_class.call(booking_id: booking.id, params: create_params)

      expect(PublishEventJob).to have_received(:perform_later).with('booking_invoices.created', context.advance_booking_invoice)
    end

    it 'creates the payment' do
      context = described_class.call(booking_id: booking.id, params: create_params)

      expect(advance_booking_invoice.payments.count).to eq(1)
    end

    it 'creates and serializes the booking_credit' do
      context = described_class.call(booking_id: booking.id, params: create_params)

      expect(BookingCredit).to have_received(:new).twice.with(
        booking: booking,
        name: I18n.t("booking_credits.advance_booking_invoice.title"),
        price_cents: 10000,
        financial_account_id: "1",
        cost_center_id: "2"
        )
      expect(booking_credit).to have_received(:save)
      expect(booking_credit).to have_received(:serialize_as_booking_resource_sku_snapshot)
      expect(advance_booking_invoice).to have_received(:booking_resource_skus_snapshot=).with([advance_payment_snapshot])
    end

    context 'when the payment_s price equals zero' do
      let(:payment) { instance_double(Payment, price: 0) }

      it 'fails and sets the error message' do
        context = described_class.call(booking_id: booking.id, params: create_params)

        expect(context).to be_a_failure
        expect(context.message).to eq(I18n.t("booking_invoices.new.invalid_price_error"))
      end
    end

    context 'with failure' do
      before do
        allow(advance_booking_invoice).to receive(:save) { false }
      end

      it 'fails' do
        context = described_class.call(booking_id: booking.id, params: create_params)

        expect(context).to be_a_failure
        expect(context.message).to eq("invalid_advance_booking_invoice")
      end
    end
  end
end

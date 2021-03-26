# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Documents::Create::BookingInvoice, type: :interactor do
  describe '.call' do
    subject { described_class.call(**organizer_params) }

    let(:booking) { create(:booking, :with_assignee, aasm_state: :in_progress) }

    let(:organizer_params) { { booking_id: booking.id, params: params } }
    let(:params) do
      { }
    end
    let(:booking_service) { instance_double(BookingService) }

    before do
      ActiveJob::Base.queue_adapter = :test
      allow(BookingService).to receive(:new) { booking_service }
      allow(booking_service).to receive(:invoice_creatable?) { true }
    end

    describe "success" do
      it { is_expected.to be_success }
    end

    describe "invoice is created" do
      it { expect { subject }.to change { BookingInvoice.count }.by(1) }
    end

    it 'publishes the message' do
      expect { subject }.to have_enqueued_job(PublishEventJob).with { |event_name, payload|
        expect(event_name).to eq('booking_invoices.created')
        expect(payload).to eq({ "id" => booking.reload.booking_invoices.last.id, "booking_id" => booking.id })
      }
    end

    it 'changes the secondary state of the booking' do
      expect { subject }.to change { booking.reload.secondary_state }.from(nil).to("invoice_sent")
    end

    context 'with a booking resource sku' do
      let!(:booking_resource_sku) { create(:booking_resource_sku, booking: booking) }
      let(:payments_attributes) do
        { "0" => { price_cents: booking_resource_sku.price_cents, due_on: Time.zone.now } }
      end

      let(:params) do
        super().merge("payments_attributes" => payments_attributes)
      end

      it 'creates a booking document reference' do
        expect { subject }.to change { booking_resource_sku.reload.invoices.count }.by(1)
      end

      it 'stores the snapshot' do
        expect(subject.document.booking_resource_skus_snapshot).to contain_exactly(
          booking_resource_sku.serialize_for_snapshot.as_json)
      end
    end

    context 'with a booking resource sku group' do
      let!(:booking_resource_sku_group) { create(:booking_resource_sku_group_with_booking_resource_skus, booking: booking) }
      let(:payments_attributes) do
        { "0" => { price_cents: booking_resource_sku_group.price_cents, due_on: Time.zone.now } }
      end

      let(:params) do
        super().merge("payments_attributes" => payments_attributes)
      end

      it 'creates a booking document reference' do
        expect { subject }.to change { booking_resource_sku_group.reload.invoices.count }.by(1)
      end

      it 'stores the snapshot' do
        expect(subject.document.booking_resource_sku_groups_snapshot).to contain_exactly(
          booking_resource_sku_group.serialize_for_snapshot.as_json)
      end
    end

    context 'with a booking credit' do
      let!(:booking_credit) { create(:booking_credit, booking: booking) }
      let(:payments_attributes) do
        { "0" => { price_cents: -booking_credit.price_cents, due_on: Time.zone.now } }
      end

      let(:params) do
        super().merge("payments_attributes" => payments_attributes)
      end

      it 'creates a booking document reference' do
        expect { subject }.to change { booking_credit.reload.invoices.count }.by(1)
      end

      it 'stores the snapshot' do
        expect(subject.document.booking_credits_snapshot).to contain_exactly(
          booking_credit.serialize_for_snapshot.as_json)
      end
    end
  end
end

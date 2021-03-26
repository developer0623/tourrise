# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Easybill::CancelInvoicesJob, type: :job do
  let(:booking_data) do
    { 'id' => 1 }
  end

  before do
    allow(ENV).to receive(:[]).with('EASYBILL_API_KEY').and_return('api_key')
    ActiveJob::Base.queue_adapter = :test
  end

  describe '.perform_later' do
    it 'queues a cancel invoices job' do
      expect do
        described_class.perform_later
      end.to have_enqueued_job
    end

    context 'when the EASYBILL_API_KEY is not configured' do
      before do
        allow(ENV).to receive(:[]).with('EASYBILL_API_KEY').and_return(nil)
      end

      it 'does not enqueue the job' do
        expect do
          described_class.perform_later
        end.not_to have_enqueued_job
      end
    end
  end

  describe '.perform' do
    let(:context) { double(:context, success?: true) }
    let(:booking_invoices) { BookingInvoice.all }
    let(:booking_invoice_ids) { [1] }
    let(:active_easybill_invoices) { Easybill::Invoice.all }
    let(:easybill_invoice) { instance_double('Easybill::Invoice') }
    let(:easybill_invoices) { [easybill_invoice] }

    before do
      allow(Easybill::CancelInvoice).to receive(:call) { context }
      allow(BookingInvoice).to receive(:where) { booking_invoices }
      allow(booking_invoices).to receive(:pluck).with(:id) { booking_invoice_ids }
      allow(Easybill::Invoice).to receive(:active) { active_easybill_invoices } 
      allow(active_easybill_invoices).to receive(:where)
        .with(booking_invoice_id: booking_invoice_ids) { easybill_invoices } 
    end

    it 'calls the cancel invoice interactor' do
      described_class.perform_now(booking_data)

      expect(Easybill::CancelInvoice).to have_received(:call).with(invoice: easybill_invoice)
    end

    context 'without any active invoice' do
      let(:easybill_invoices) { [] }

      it 'does not call the cancel invoice interactor' do
        described_class.perform_now(booking_data)

        expect(Easybill::CancelInvoice).not_to have_received(:call)
      end
    end
  end
end


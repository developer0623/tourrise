# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Easybill::CreateInvoiceJob, type: :job do
  let(:booking_invoice_data) do
    { 'id' => 1 }
  end

  before do
    allow(ENV).to receive(:[]).with('EASYBILL_API_KEY').and_return('api_key')
    ActiveJob::Base.queue_adapter = :test
  end

  describe '.perform_later' do
    it 'queues a create invoice job' do
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

    before do
      allow(Easybill::CreateInvoice).to receive(:call) { context }
    end

    it 'calls the create invoice interactor' do
      described_class.perform_now(booking_invoice_data)

      expect(Easybill::CreateInvoice).to have_received(:call).with(data: booking_invoice_data)
    end

    context 'when the invoice creation failed and the error is unkown' do
      let(:context) { double(:context, success?: false, error: :error_message) }

      it 'raises an error' do
        expect do
          described_class.perform_now(booking_invoice_data)
        end.to raise_error('CreateInvoice failed with: error_message')
      end
    end

    context 'when the invoice creation fails and the error is easybill_customer_not_created' do
      let(:customer) { double(:customer, as_json: { 'id' => 'customer_id' }) }
      let(:booking) { double(:booking, customer: customer) }
      let(:context) { double(:context, success?: false, booking: booking, error: :easybill_customer_not_created) }

      before do
        allow(Easybill::CreateCustomerJob).to receive(:perform_later)
      end

      it 'queues a create customer job' do
        described_class.perform_now(booking_invoice_data)

        expect(Easybill::CreateCustomerJob).to have_received(:perform_later).with({ 'id' => 'customer_id' })
      end

      it 'retries the create invoice job in 5 seconds' do
        described_class.perform_now(booking_invoice_data)

        expect(described_class).to have_been_enqueued
      end
    end
  end
end

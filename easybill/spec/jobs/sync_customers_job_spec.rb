# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Easybill::SyncCustomersJob, type: :job do
  before do
    allow(ENV).to receive(:[]).with('EASYBILL_API_KEY').and_return('api_key')
    ActiveJob::Base.queue_adapter = :test
  end

  describe '.perform_later' do
    it 'uploads a backup' do
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
    let(:sync_date) { Time.zone.now }
    let(:customer) { double(:customer, as_json: { 'id' => 1 }) }

    let(:customers_to_create_context) do
      double(:customers_to_create_context, customers: [customer])
    end

    let(:customers_to_update_context) do
      double(:customers_to_update_context, customers: [customer])
    end

    before do
      allow(DateTime).to receive(:now) { sync_date }
      allow(Easybill::CustomerSync).to receive(:create)
      allow(Easybill::ListCustomersToCreate).to receive(:call) { customers_to_create_context }
      allow(Easybill::ListCustomersToUpdate).to receive(:call) { customers_to_update_context }
      allow(Easybill::CreateCustomerJob).to receive(:perform_later)
      allow(Easybill::UpdateCustomerJob).to receive(:perform_later)
    end

    it 'queues the customers to create jobs' do
      described_class.perform_now

      expect(Easybill::CreateCustomerJob).to have_received(:perform_later).with({ 'id' => 1})
    end

    it 'queues the customers to update jobs' do
      described_class.perform_now

      expect(Easybill::UpdateCustomerJob).to have_received(:perform_later).with({ 'id' => 1})
    end

    it 'sets the last synced at timestamp' do
      described_class.perform_now

      expect(Easybill::CustomerSync).to have_received(:create).with(last_sync_at: sync_date)
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Easybill::UpdateCustomerJob, type: :job do
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
    let(:customer_data) { 'data' }

    before do
      allow(Easybill::UpdateCustomer).to receive(:call)
    end

    it 'calls the update customer interactor' do
      described_class.perform_now(customer_data)

      expect(Easybill::UpdateCustomer).to have_received(:call).with(data: 'data')
    end
  end
end

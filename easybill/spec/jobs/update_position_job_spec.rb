# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Easybill::UpdatePositionJob, type: :job do
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
    let(:resource_sku_data) { 'data' }
    let(:context) { double(:context) }

    before do
      allow(Easybill::UpdatePosition).to receive(:call) { context }
      allow(context).to receive(:success?) { true }
    end

    it 'calls the update position interactor' do
      described_class.perform_now(resource_sku_data)

      expect(Easybill::UpdatePosition).to have_received(:call).with(data: 'data')
    end

    context 'when the position has not been synced yet' do
      before do
        allow(context).to receive(:success?) { false}
        allow(context).to receive(:message) { :not_found }
        allow(Easybill::CreatePositionJob).to receive(:perform_later)
      end

      it 'enqueues a create position job' do
        described_class.perform_now(resource_sku_data)

        expect(Easybill::CreatePositionJob).to have_received(:perform_later).with('data')
      end
    end
  end
end


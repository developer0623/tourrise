require 'rails_helper'

describe Easybill::ResourceSkuCreatedHandler, type: :handler do
  let(:resource_sku_data) { 'data' }

  before do
    allow(Easybill::CreatePositionJob).to receive(:perform_later)
  end

  describe '.handle' do
    it 'queues a create position job' do
      described_class.handle(resource_sku_data)

      expect(Easybill::CreatePositionJob).to have_received(:perform_later).with('data')
    end
  end
end


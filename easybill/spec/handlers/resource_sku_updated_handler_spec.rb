require 'rails_helper'

describe Easybill::ResourceSkuUpdatedHandler, type: :handler do
  let(:resource_sku_data) { 'data' }

  before do
    allow(Easybill::UpdatePositionJob).to receive(:perform_later)
  end

  describe '.handle' do
    it 'queues an update position job' do
      described_class.handle(resource_sku_data)

      expect(Easybill::UpdatePositionJob).to have_received(:perform_later).with('data')
    end
  end
end


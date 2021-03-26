require 'rails_helper'

describe Easybill::ResourceCreatedHandler, type: :handler do
  let(:resource_data) { 'data' }

  before do
    allow(Easybill::CreatePositionGroupJob).to receive(:perform_later)
  end

  describe '.handle' do
    it 'queues a create position group job' do
      described_class.handle(resource_data)

      expect(Easybill::CreatePositionGroupJob).to have_received(:perform_later).with('data')
    end
  end
end


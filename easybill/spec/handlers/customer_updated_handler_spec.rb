require 'rails_helper'

describe Easybill::CustomerUpdatedHandler, type: :handler do
  let(:customer_data) { 'data' }

  before do
    allow(Easybill::UpdateCustomerJob).to receive(:perform_later)
  end

  describe '.handle' do
    it 'queues an update customer job' do
      described_class.handle(customer_data)

      expect(Easybill::UpdateCustomerJob).to have_received(:perform_later).with('data')
    end
  end
end

require 'rails_helper'

describe Easybill::CustomerCreatedHandler, type: :handler do
  let(:customer_data) { 'data' }

  before do
    allow(Easybill::CreateCustomerJob).to receive(:perform_later)
  end

  describe '.handle' do
    it 'queues a create customer job' do
      described_class.handle(customer_data)

      expect(Easybill::CreateCustomerJob).to have_received(:perform_later).with('data')
    end
  end
end

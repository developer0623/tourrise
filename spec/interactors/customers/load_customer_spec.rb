require 'rails_helper'

RSpec.describe Customers::LoadCustomer, type: :interactor do
  subject(:context) { described_class.call(customer_id: 'customer_id') }

  describe '.call' do
    context 'when the customer exists' do
      let(:customer) { double(:customer, custom_attribute_ids: []) }

      before do
        allow(Customer).to receive(:find_by).with(id: 'customer_id') { customer }
      end

      it 'succeeds' do
        expect(context).to be_success
      end

      it 'provides the customer' do
        expect(context.customer).to eq(customer)
      end
    end

    context 'when the customer does not exists' do
      before do
        allow(Customer).to receive(:find_by).with(id: 'customer_id') { nil }
      end

      it 'fails' do
        expect(context).to be_failure
      end

      it 'provides the error message' do
        expect(context.message).to eq(:not_found)
      end
    end
  end
end

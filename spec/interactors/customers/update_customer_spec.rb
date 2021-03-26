# frozen_string_literar: true

require 'rails_helper'

RSpec.describe Customers::UpdateCustomer, type: :interactor do
  describe '.call' do
    let(:customer_id) { 1 }
    let(:customer_params) do
      {
        first_name: 'first_name',
        last_name: 'last_name',
        email: 'email'
      }
    end
    let(:customer) { instance_double('Customer', id: customer_id) }

    before do
      allow(Customer).to receive(:find) { customer }
      allow(customer).to receive(:update) { true }
      allow(PublishEventJob).to receive(:perform_later)
    end

    it 'loads the customer' do
      described_class.call(customer_id: customer_id, params: customer_params)

      expect(Customer).to have_received(:find).with(customer_id)
    end

    it 'updates the customer' do
      described_class.call(customer_id: customer_id, params: customer_params)

      expect(customer).to have_received(:update).with(customer_params)
    end

    it 'is successful' do
      context = described_class.call(customer_id: customer_id, params: customer_params)

      expect(context.success?).to be(true)
    end

    it 'sets the context' do
      context = described_class.call(customer_id: customer_id, params: customer_params)

      expect(context.customer).to eq(customer)
    end

    it 'publishes the message' do
      context = described_class.call(customer_id: customer_id, params: customer_params)

      expect(PublishEventJob).to have_received(:perform_later).with('customers.updated', context.customer)
    end

    context 'when the customer does not exist' do
      before do
        allow(Customer).to receive(:find).and_call_original
      end

      it 'raises an error' do
        expect {
          described_class.call(customer_id: customer_id, params: customer_params)
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'with failure' do
      before do
        allow(Customer).to receive(:find) { customer }
        allow(customer).to receive(:update) { false }
        allow(customer).to receive(:errors) { double(:errors, full_messages: :error_messages) }
        allow(Amqp::Client).to receive(:publish)
      end

      it 'is a failure' do
        context = described_class.call(customer_id: customer_id, params: customer_params)

        expect(context).to be_a_failure
      end

      it 'sets the errors context' do
        context = described_class.call(customer_id: customer_id, params: customer_params)

        expect(context.message).to eq(:error_messages)
      end

      it 'does not publish the amqp message' do
        context = described_class.call(customer_id: customer_id, params: customer_params)

        expect(PublishEventJob).not_to have_received(:perform_later).with(any_args)
      end
    end
  end
end

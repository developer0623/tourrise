# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Customers::CreateCustomer, type: :interactor do
  describe '.call' do
    let(:customer_params) do
      {
        first_name: 'first_name',
        last_name: 'last_name',
        email: 'email'
      }
    end
    let(:customer) { instance_double('Customer', id: 2) }

    before do
      allow(Customer).to receive(:new) { customer }
      allow(customer).to receive(:save) { true }
      allow(customer).to receive(:update_attribute) { true }
      allow(customer).to receive(:id) { 2 }
      allow(PublishEventJob).to receive(:perform_later)
    end

    it 'initializes a new customer' do
      described_class.call(params: customer_params)

      expect(Customer).to have_received(:new).with(customer_params)
    end

    it 'is successful' do
      context = described_class.call(params: customer_params)

      expect(context.success?).to be(true)
    end

    it 'sets the context' do
      context = described_class.call(params: customer_params)

      expect(context.customer).to eq(customer)
    end

    it 'publishes the message' do
      context = described_class.call(params: customer_params)

      expect(PublishEventJob).to have_received(:perform_later).with('customers.created', context.customer)
    end

    it 'adds the general_customer_id' do
      context = described_class.call(params: customer_params)

      expect(context.customer).to have_received(:update_attribute).with(:general_customer_id, 10002)
    end

    context 'with failure' do
      before do
        allow(Customer).to receive(:new) { customer }
        allow(customer).to receive(:save) { false }
        allow(customer).to receive(:errors) { :error_messages }
      end

      it 'is a failure' do
        context = described_class.call(params: customer_params)

        expect(context).to be_a_failure
      end

      it 'sets the errors context' do
        context = described_class.call(params: customer_params)

        expect(context.message).to eq(:error_messages)
      end

      it 'does not publish the amqp message' do
        context = described_class.call(params: customer_params)

        expect(PublishEventJob).not_to have_received(:perform_later).with(any_args)
      end
    end

    context 'when the general_customer_id could not be set' do
      before do
        allow(customer).to receive(:update_attribute) { false }
      end

      it 'is a failure' do
        context = described_class.call(params: customer_params)

        expect(context).to be_a_failure
      end

      it 'sets the correct error message' do
        context = described_class.call(params: customer_params)

        expect(context.message).to eq(I18n.t("customers.create.general_id_error"))
      end
    end
  end
end


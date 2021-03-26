# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Easybill::UpdateCustomer, type: :interactor do
  describe '.call' do
    let(:customer_data) do
      { 'id' => 1234 }
    end

    let(:customer) { instance_double(Customer) }
    let(:easybill_customer_data) { {} }
    let(:easybill_service) { instance_double(Easybill::ApiService) }
    let(:update_customer_response) do
      double(:update_customer_response, success?: true)
    end

    let(:easybill_customer_id) { 9876 }
    let(:easybill_external_id) { 'easybill_external_id' }
    let(:easybill_customer) do
      instance_double(Easybill::Customer, external_id: easybill_external_id, id: easybill_customer_id, touch: true)
    end

    before do
      allow(Easybill::Customer).to receive(:find_by) { easybill_customer }
      allow(Customer).to receive(:find) { customer }
      allow(customer).to receive(:bookings) { %w[booking] }
      allow(Easybill::CustomerMapper).to receive(:to_easybill_customer) { easybill_customer_data }
      allow(Easybill::ApiService).to receive(:new) { easybill_service }
      allow(easybill_service).to receive(:update_customer) { update_customer_response }
      allow(update_customer_response).to receive(:[]).with('id').and_return('easybill_id')
    end

    it 'loads the easybill customer' do
      described_class.call(data: customer_data)

      expect(Easybill::Customer).to have_received(:find_by).with(customer_id: 1234)
    end

    it 'loads the customer' do
      described_class.call(data: customer_data)

      expect(Customer).to have_received(:find).with(1234)
    end

    it 'maps the customer to easybill data' do
      described_class.call(data: customer_data)

      expect(Easybill::CustomerMapper).to have_received(:to_easybill_customer).with(customer)
    end

    it 'calls the easybill service to create the customer' do
      described_class.call(data: customer_data)

      expect(easybill_service).to have_received(:update_customer).with('easybill_external_id', easybill_customer_data)
    end

    it 'touches the easybill customer sync entry' do
      described_class.call(data: customer_data)

      expect(easybill_customer).to have_received(:touch).with(no_args)
    end

    context 'when the easybill customer does not exist' do
      let(:easybill_customer) { nil }

      before do
        allow(Easybill::Customer).to receive(:find_by) { easybill_customer }
      end

      it 'has a failed context' do
        context = described_class.call(data: customer_data)

        expect(context).to be_failure
      end
    end
  end
end

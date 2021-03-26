# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Easybill::CreateCustomer, type: :interactor do
  describe '.call' do
    let(:customer_data) do
      { 'id' => 1234 }
    end
    let(:customer) { instance_double(Customer) }
    let(:easybill_customer_data) { {} }
    let(:easybill_service) { instance_double(Easybill::ApiService) }
    let(:create_customer_response) do
      double(:create_customer_response, success?: true)
    end

    before do
      allow(Customer).to receive(:find) { customer }
      allow(customer).to receive(:bookings) { %w[booking] }
      allow(Easybill::CustomerMapper).to receive(:to_easybill_customer) { easybill_customer_data }
      allow(Easybill::ApiService).to receive(:new) { easybill_service }
      allow(easybill_service).to receive(:create_customer) { create_customer_response }
      allow(Easybill::Customer).to receive(:create!)
      allow(create_customer_response).to receive(:[]).with('id').and_return('easybill_id')
    end

    it 'loads the backoffice customer' do
      described_class.call(data: customer_data)

      expect(Customer).to have_received(:find).with(1234)
    end

    it 'maps the customer to easybill data' do
      described_class.call(data: customer_data)

      expect(Easybill::CustomerMapper).to have_received(:to_easybill_customer).with(customer)
    end

    it 'calls the easybill service to create the customer' do
      described_class.call(data: customer_data)

      expect(easybill_service).to have_received(:create_customer).with(easybill_customer_data)
    end

    it 'creates the easybill customer sync entry' do
      described_class.call(data: customer_data)

      expect(Easybill::Customer).to have_received(:create!).with(
        customer: customer,
        external_id: 'easybill_id'
      )
    end

    context 'when the easybill customer already exist' do
      let(:easybill_customer) { double(:easybill_customer) }

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

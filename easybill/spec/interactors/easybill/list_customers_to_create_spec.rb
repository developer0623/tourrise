# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Easybill::ListCustomersToCreate, type: :interactor do
  describe '.call' do
    let(:customer) do
      Customer.create(email: 'foo@bar.de', first_name: 'foo', last_name: 'bar')
    end

    let(:bookings) { object_double(Booking.all) }
    let(:contact_customer_ids) { [customer.id] }

    before do
      allow(Booking).to receive(:without_drafts) { bookings }
      allow(bookings).to receive(:pluck).with(:customer_id) { contact_customer_ids }
    end

    context 'with easybill customer entry' do
      it 'does not include the created customer' do
        Easybill::Customer.create!(external_id: 1, customer: customer)

        context = described_class.call

        expect(context.customers).to be_empty
      end
    end

    context 'without easybill customer entry' do
      it 'includes the customer in the response' do
        context = described_class.call

        expect(context.customers).to contain_exactly(customer)
      end
    end

    context 'when customer is a participant' do
      let(:contact_customer_ids) { [] }

      before do
        allow(Booking).to receive(:without_drafts) { bookings }
        allow(bookings).to receive(:pluck).with(:customer_id) { contact_customer_ids }
      end

      it 'does not include the customer' do
        context = described_class.call

        expect(context.customers).to be_empty
      end
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Easybill::ListCustomersToUpdate, type: :interactor do
  describe '.call' do
    let(:customers) { object_double(Customer.all) }
    let(:contact_customers) { object_double(Customer.all) }

    let(:last_synced_at) { DateTime.new(2010, 10, 10) }
    let(:bookings) { object_double(Booking.all) }

    let(:contact_customer_ids) { %w[one two] }

    before do
      allow(Booking).to receive(:without_drafts) { bookings }
      allow(bookings).to receive(:pluck).with(:customer_id) { contact_customer_ids }

      allow(Customer).to receive(:where) { contact_customers }

      allow(contact_customers).to receive(:where) { customers }
    end

    it 'searches only customers that belong to a booking' do
      Easybill::CustomerSync.create(last_sync_at: last_synced_at)

      described_class.call

      expect(Customer).to have_received(:where).with(id: %w[one two])
    end

    it 'searches for recently updated customers' do
      Easybill::CustomerSync.create(last_sync_at: last_synced_at)

      described_class.call

      expect(contact_customers).to have_received(:where).with('updated_at >= ?', last_synced_at)
    end

    it 'sets the customers to the context' do
      context = described_class.call

      expect(context.customers).to eq(customers)
    end

    context 'without last sync at' do
      it 'starts the update since the beginning of time' do
        described_class.call

        expect(contact_customers).to have_received(:where).with('updated_at >= ?', DateTime.new)
      end
    end

    context 'when customer is a participant' do
      let(:contact_customer_ids) { [] }

      before do
        allow(Booking).to receive(:without_drafts) { bookings }
        allow(bookings).to receive(:pluck).with(:customer_id) { contact_customer_ids }
      end

      it 'searches only customers that belong to a booking' do
        Easybill::CustomerSync.create(last_sync_at: last_synced_at)

        described_class.call

        expect(Customer).to have_received(:where).with(id: [])
      end
    end
  end
end

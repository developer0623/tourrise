require 'rails_helper'

RSpec.describe BookingInvoices::Index::List, type: :interactor do
  describe '.call' do
    let!(:booking_invoice) { create(:booking_invoice) }

    it 'returns the paginated booking invoices' do
      result = described_class.call

      expect(result.booking_invoices).to contain_exactly(booking_invoice)
    end

    it 'paginates the collection' do
      result = described_class.call

      expect(result.booking_invoices.total_count).to eq(1)
      expect(result.booking_invoices.total_pages).to eq(1)
    end

    context 'with created_at gt filter' do
      let(:created_at) { Time.zone.now }
      let!(:booking_invoice) { create(:booking_invoice, created_at: created_at - 1.hour) }
      let!(:another_booking_invoice) { create(:booking_invoice, created_at: created_at + 1.hour) }

      let(:filter) do
        {
          created_at: {
            operator: 'gt',
            value: created_at.iso8601
          }
        }
      end

      it 'returns the booking_invoices that have been created after the provided date' do
        result = described_class.call(filter: filter)

        expect(result.booking_invoices).to contain_exactly(another_booking_invoice)
      end
    end
  end
end

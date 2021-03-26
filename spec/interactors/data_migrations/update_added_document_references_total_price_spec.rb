require 'rails_helper'

RSpec.describe DataMigrations::UpdateAddedDocumentReferencesTotalPrice, type: :interactor do
  let(:booking_resource_sku) { create(:booking_resource_sku, quantity: 1, price: Money.new(1234)) }
  let(:document) { create(:booking_invoice, created_at: Time.zone.now) }
  let!(:document_reference) do
    create(
      :document_reference,
      event: :added,
      item: booking_resource_sku,
      document: document,
      item_version_id: booking_resource_sku.versions.last.id,
      price_cents: 0
    )
  end

  describe '.call' do
    it 'sets the price' do
      expect {
        described_class.call
        document_reference.reload
      }.to change { document_reference.price }.from(Money.new(0)).to(Money.new(1234))
    end

    context 'when the total price is set' do
      let!(:document_reference) { create(:document_reference, price_cents: 1234, item_version_id: 1) }

      it 'does not update the total price' do
        expect {
          described_class.call
          document_reference.reload
        }.not_to change { document_reference.price }
      end
    end

    context 'when the event is other than added' do
      let!(:document_reference) { create(:document_reference, event: :modified, price_cents: 0, item_version_id: 1) }

      it 'does not update the total price' do
        expect {
          described_class.call
          document_reference.reload
        }.not_to change { document_reference.price }
      end
    end

    context 'when the item is already deleted' do
      before do
        booking_resource_sku.destroy
      end

      it 'updates the price' do
        expect {
          described_class.call
          document_reference.reload
        }.to change { document_reference.price }.from(Money.new(0)).to(Money.new(1234))
      end
    end

    context 'when the total price changed after it got invoiced' do
      before do
        document_reference
        booking_resource_sku.update(price: Money.new(420))
      end

      it 'updates the price to the version of the document' do
        expect {
          described_class.call
          document_reference.reload
        }.to change { document_reference.price }.from(Money.new(0)).to(Money.new(1234))
      end
    end
  end
end

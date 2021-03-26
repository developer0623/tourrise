require 'rails_helper'

RSpec.describe ProductSkus::DestroyProductSku, type: :interactor do
  let(:product) { instance_double(Product) }
  let(:product_sku) { instance_double(ProductSku, name: 'a product sku') }

  let(:call_context) do
    {
      product_id: 'product_id',
      product_sku_id: 'product_sku_id',
      product: product,
      product_sku: product_sku
    }
  end

  let(:bookings) { object_double(Booking.all, any?: false) }

  before do
    allow(Products::LoadProduct).to receive(:call!) { product }
    allow(ProductSkus::LoadProductSku).to receive(:call!) { product_sku }
    allow(product_sku).to receive(:bookings) { bookings }
    allow(product_sku).to receive(:destroy) { true }
    allow(bookings).to receive(:without_drafts) { bookings }
  end

  describe '.call' do
    it 'loads the product' do
      described_class.call(call_context)

      expect(Products::LoadProduct).to have_received(:call!)
    end

    it 'loads the product_sku' do
      described_class.call(call_context)

      expect(ProductSkus::LoadProductSku).to have_received(:call!)
    end

    it 'it destroys the product sku' do
      described_class.call(call_context)

      expect(product_sku).to have_received(:destroy).with(no_args)
    end

    context' when the product sku has bookings' do
      let(:bookings) { object_double(Booking.all, any?: true) }

      it 'does not destroy the product sku' do
        described_class.call(call_context)

        expect(product_sku).not_to have_received(:destroy)
      end

      it 'has an error context' do
        result = described_class.call(call_context)

        expect(result).to be_failure
      end

      it 'has a error message' do
        result = described_class.call(call_context)

        expect(result.message).to eq("a product sku hat aktive Buchungen. Kann nicht entfernt werden.")
      end
    end

    context 'when the product sku is not deletable' do
      before do
        allow(product_sku).to receive(:destroy) { false }
        allow(product_sku).to receive(:errors) { double("errors", full_messages: "error_messages") }
      end

      it 'tries to destroy the product sku' do
        described_class.call(call_context)

        expect(product_sku).to have_received(:destroy).with(no_args)
      end

      it 'has an error context' do
        result = described_class.call(call_context)

        expect(result).to be_failure
      end

      it 'has a error message' do
        result = described_class.call(call_context)

        expect(result.message).to eq("error_messages")
      end
    end
  end
end

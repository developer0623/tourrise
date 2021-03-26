# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Products::UpdateSku, type: :interactor do
  subject(:context) do
    described_class.call(
      product_id: product.id,
      sku_id: sku.id,
      params: {}
    )
  end

  let(:product) { instance_double('Products::Product', id: 1) }
  let(:sku) { instance_double('ProductSku', id: 1, product_id: product.id) }

  describe '.call' do
    let(:load_sku_context) { double('load_sku_context', success?: true, sku: sku) }

    before do
      allow(Products::LoadSku).to receive(:call)
        .once
        .with(
          product_id: product.id,
          sku_id: sku.id
        )
        .and_return(load_sku_context)
    end

    context 'missing sku' do
      let(:load_sku_context) do
        double('load_sku_context', success?: false, message: 'message')
      end

      it 'fails' do
        expect(context).to be_a_failure
      end

      it 'provides an error message' do
        expect(context.message).to eq('message')
      end
    end

    context 'existing sku' do
      let(:load_sku_context) { double('load_sku_context', success?: true, sku: sku) }

      before do
        allow(sku).to receive(:update).and_return(true)
        allow(sku).to receive(:reload).and_return(sku)
      end

      it 'succeeds' do
        expect(context).to be_a_success
      end

      it 'sets the sku context' do
        expect(context.sku).to eq(sku)
      end
    end
  end
end

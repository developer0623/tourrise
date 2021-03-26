# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Easybill::UpdatePosition, type: :interactor do
  describe '.call' do
    let(:resource_sku_data) { { 'id' => 'resource_sku_id' } }
    let(:resource_sku) do
      instance_double(ResourceSku, id: 'resource_sku_id', resource_id: 'resource_id')
    end
    let(:mapped_position_data) { 'data' }
    let(:easybill_service) { instance_double(Easybill::ApiService) }
    let(:position_response) { double(:position_response, success?: true) }

    let(:position) do
      instance_double(Easybill::Position, id: 'position_id', external_id: 'external_position_id')
    end

    before do
      allow(ResourceSku).to receive(:find) { resource_sku }
      allow(Easybill::ResourceSkuMapper).to receive(:to_easybill_position) { mapped_position_data }
      allow(Easybill::Position).to receive(:find_by) { position }
      allow(Easybill::ApiService).to receive(:new) { easybill_service }
      allow(easybill_service).to receive(:update_position) { position_response }
      allow(position_response).to receive(:[]).with('id') { 'easybill_position_id' }
      allow(position).to receive(:touch)
    end

    it 'maps the resource sku data to an easybill position' do
      described_class.call(data: resource_sku_data)

      expect(Easybill::ResourceSkuMapper).to have_received(:to_easybill_position).with(resource_sku)
    end

    it 'updates the easybill position via the service' do
      described_class.call(data: resource_sku_data)

      expect(easybill_service).to have_received(:update_position).with(
        'external_position_id',
        mapped_position_data
      )
    end

    it 'is successful' do
      context = described_class.call(data: resource_sku_data)

      expect(context).to be_success
    end

    it 'touches the position' do
      described_class.call(data: resource_sku_data)

      expect(position).to have_received(:touch).with(no_args)
    end

    context 'when the mapping fails' do
      before do
        allow(Easybill::ResourceSkuMapper).to receive(:to_easybill_position).and_raise('an error')
      end

      it 'raises an error' do
        expect {
          described_class.call(data: resource_sku_data)
        }.to raise_error('an error')

      end
    end

    context 'when the service responds with an error' do
      let(:position_response) { double(:position_response, success?: false) }

      it 'sets a failure context' do
        context = described_class.call(data: resource_sku_data)

        expect(context.failure?).to be(true)
      end

      it 'does not touch the position' do
        described_class.call(data: resource_sku_data)

        expect(position).not_to have_received(:touch)
      end
    end
  end
end


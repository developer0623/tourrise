# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Easybill::CreatePosition, type: :interactor do
  describe '.call' do
    let(:resource_sku_data) { { 'id' => 'resource_sku_id' } }
    let(:resource_sku) do
      instance_double(ResourceSku, id: 'resource_sku_id', resource_id: 'resource_id')
    end
    let(:mapped_position_data) { 'data' }
    let(:position_group) { instance_double(Easybill::PositionGroup, id: 'position_group_id') }
    let(:easybill_service) { instance_double(Easybill::ApiService) }
    let(:position_response) { double(:position_response, success?: true) }

    before do
      allow(ResourceSku).to receive(:find) { resource_sku }
      allow(Easybill::ResourceSkuMapper).to receive(:to_easybill_position) { mapped_position_data }
      allow(Easybill::PositionGroup).to receive(:find_by!) { position_group }
      allow(Easybill::ApiService).to receive(:new) { easybill_service }
      allow(easybill_service).to receive(:create_position) { position_response }
      allow(position_response).to receive(:[]).with('id') { 'easybill_position_id' }
      allow(Easybill::Position).to receive(:create!)
    end

    it 'maps the resource sku data to an easybill position' do
      described_class.call(data: resource_sku_data)

      expect(Easybill::ResourceSkuMapper).to have_received(:to_easybill_position).with(resource_sku)
    end

    it 'creates the easybill position via the service' do
      described_class.call(data: resource_sku_data)

      expect(easybill_service).to have_received(:create_position).with(mapped_position_data)
    end

    it 'is successful' do
      context = described_class.call(data: resource_sku_data)

      expect(context).to be_success
    end

    it 'persists the position' do
      described_class.call(data: resource_sku_data)

      expect(Easybill::Position).to have_received(:create!).with(
        resource_sku_id: 'resource_sku_id',
        external_id: 'easybill_position_id'
      )
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

      it 'does not save the position' do
        described_class.call(data: resource_sku_data)

        expect(Easybill::Position).not_to have_received(:create!)
      end
    end
  end
end


# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Easybill::CreatePositionGroup, type: :interactor do
  describe '.call' do
    let(:resource_data) { { 'id' => 'resource_id' } }
    let(:resource) do
      instance_double(Resource, id: 'resource_id')
    end
    let(:mapped_position_group_data) { 'data' }
    let(:easybill_service) { instance_double(Easybill::ApiService) }
    let(:position_group_response) { double(:position_group_response, success?: true) }

    before do
      allow(Resource).to receive(:find) { resource }
      allow(Easybill::ResourceMapper).to receive(:to_easybill_position_group) { mapped_position_group_data }
      allow(Easybill::ApiService).to receive(:new) { easybill_service }
      allow(easybill_service).to receive(:create_position_group) { position_group_response }
      allow(position_group_response).to receive(:[]).with('id') { 'easybill_position_group_id' }
      allow(Easybill::PositionGroup).to receive(:create!)
    end

    it 'maps the resource data to an easybill position group' do
      described_class.call(data: resource_data)

      expect(Easybill::ResourceMapper).to have_received(:to_easybill_position_group).with(resource)
    end

    it 'creates the easybill position group via the service' do
      described_class.call(data: resource_data)

      expect(easybill_service).to have_received(:create_position_group).with(mapped_position_group_data)
    end

    it 'is successful' do
      context = described_class.call(data: resource_data)

      expect(context).to be_success
    end

    it 'persists the position group' do
      described_class.call(data: resource_data)

      expect(Easybill::PositionGroup).to have_received(:create!).with(
        resource_id: 'resource_id',
        external_id: 'easybill_position_group_id'
      )
    end

    context 'when the mapping fails' do
      before do
        allow(Easybill::ResourceMapper).to receive(:to_easybill_position_group).and_raise('an error')
      end

      it 'raises an error' do
        expect {
          described_class.call(data: resource_data)
        }.to raise_error('an error')

      end
    end

    context 'when the service responds with an error' do
      let(:position_group_response) { double(:position_group_response, success?: false) }

      it 'sets a failure context' do
        context = described_class.call(data: resource_data)

        expect(context.failure?).to be(true)
      end

      it 'does not save the position group' do
        described_class.call(data: resource_data)

        expect(Easybill::PositionGroup).not_to have_received(:create!)
      end
    end
  end
end


